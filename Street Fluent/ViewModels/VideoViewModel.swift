import Foundation
import AVFoundation

@Observable
class VideoViewModel{
    let video: Video
    var player: AVPlayer?
    var isVideoPaused = false
    var isPlaying = false
    var currentDialogueIndex = 0
    var mode: LearningMode = .speaking
    var recordingState: RecordingState = .idle
    
    var audioLevels: [CGFloat] = [] // waveform bar heights
    var playbackProgress: CGFloat = 0 //recording playback
    var isPlayingBack = false
    
    var currentDialogueScore: Int? = nil //nil means not yet evaluated
    var perDialogueScores: [Int: Int] = [:] //index : score
    var showScoreCard = false    // triggers the sheet
    var sessionComplete = false  // marks video as finished
    
    var currentSubtitle = ""
    var currentTranslation = ""
    var currentWords: [Vocabulary] = [] // whats this for?
    var currentWordsIndex: Int = 0
    
    var selectedWord: Vocabulary? = nil //to show dictionary when word tapped
    
    var strokes: [[CGPoint]] = []         // completed strokes
    var currentStroke: [CGPoint] = []     // stroke being drawn right now
    var showTracingGuide: Bool = false
    
    private var boundaryObserver: Any?   // runs at each dialogue endpoint
    private var periodicObserver: Any?   // runs every 0.2s to update subtitles
    private var audioRecorder: AVAudioRecorder? //built-in recorder
    private var audioLevelsTimer: Timer? // checks audio levels after 0.05 sec
    private var audioRecordingURL: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
    } //temp save the recording for playbacks
    private var audioPlayer: AVAudioPlayer?
    private var playbackTimer: Timer?
    
    var currentWord: Vocabulary? {
        guard let dialogue = currentDialogue,
              dialogue.words.indices.contains(currentWordsIndex) else { return nil }
        return dialogue.words[currentWordsIndex]
    }
    
    var currentDialogue: Dialogue? {
        guard video.dialogues.indices.contains(currentDialogueIndex) else {return nil}
        return video.dialogues[currentDialogueIndex]
    }
    
    var isLastDialogue: Bool {
        currentDialogueIndex >= video.dialogues.count - 1
    }
    
    var hasDialogues: Bool {
        !video.dialogues.isEmpty
    }
    
    var dialogueProgress: String {
        "\(currentDialogueIndex + 1) / \(video.dialogues.count)" // dialogue num 1/10
    }
    
    var overallScore: Int {
        guard !perDialogueScores.isEmpty else { return 0 }
        let total = perDialogueScores.values.reduce(0, +)
        return total / perDialogueScores.count
    } //avg of all recorded dialogues + excludes the skipped ones
    
    init(video: Video) {
        self.video = video
    }
    
    func setupPlayer() {
        // Try .mov first, then .mp4
        let url = Bundle.main.url(forResource: video.videoURL, withExtension: "mov") ??
                  Bundle.main.url(forResource: video.videoURL, withExtension: "mp4")
        guard let url else {
            print("⚠️ Video not found: \(video.videoURL).mov or \(video.videoURL).mp4 — add it to your Xcode project")
            return
        }

        player = AVPlayer(playerItem: AVPlayerItem(url: url))
        setupBoundaryObserver()
        setupPeriodicObserver()
        updateSubtitles()
    }
    
    //runs when dialogue ends
    private func setupBoundaryObserver() {
            guard let player, hasDialogues else { return }
            
            // Convert each dialogue's endTime to CMTime (AVPlayer's time format)
            let boundaries = video.dialogues.map { dialogue in
                NSValue(time: CMTime(seconds: dialogue.endTime, preferredTimescale: 600))
            }
            
            // When player crosses any boundary → pause
            boundaryObserver = player.addBoundaryTimeObserver(
                forTimes: boundaries,
                queue: .main
            ) { [weak self] in
                self?.pause()
                self?.isVideoPaused = true
            }
        }
    
    //runs every 0.2 seconds
    private func setupPeriodicObserver() {
            guard let player else { return }  //unwrap player?
            
            periodicObserver = player.addPeriodicTimeObserver(
                forInterval: CMTime(seconds: 0.2, preferredTimescale: 600),
                queue: .main
            ) { [weak self] time in
                self?.updateDialogueForTime(time.seconds) //check which dialogue we at
            }
        }
    
    func play() {
        player?.play()
            isPlaying = true
        }
        
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    //----- control bar functions - speaking mode
    
    func skipToNextDialogue() {
        resetRecording() //clear previous recording
        isVideoPaused = false
        
        guard !isLastDialogue else {
            pause()
            showScoreCard = true //show card when last dialogue skipped
            return
        }
        
        currentDialogueIndex += 1 //skip dialogue
        updateSubtitles()
        
        // move to next dialogues start time and resume playing
        if let next = currentDialogue {
            player?.seek(to: CMTime(seconds: next.startTime, preferredTimescale: 600)) { [weak self] _ in
                self?.play()
            }
        }
    }
    
    func replayCurrentDialogue() {
        guard let dialogue = currentDialogue else { return }
        isVideoPaused = false
        
        player?.seek(to: CMTime(seconds: dialogue.startTime, preferredTimescale: 600)) { [weak self] _ in
            self?.play()
        }
    }
    
    
    //checks which dialogue we on at this time
    private func updateDialogueForTime(_ seconds: TimeInterval) {
        for (index, dialogue) in video.dialogues.enumerated() {
            if seconds >= dialogue.startTime && seconds < dialogue.endTime {
                if currentDialogueIndex != index {
                    currentDialogueIndex = index 
                    updateSubtitles()
                }
                return
            }
        }
    }
    
    //show current dialogus sub and trans
    private func updateSubtitles() {
        currentWordsIndex = 0 //reset
        clearCanvas()
//        showTracingGuide = false
        
        guard let dialogue = currentDialogue else { //check if dialogue exists
            currentSubtitle = ""
            currentTranslation = ""
            currentWords = []
            return
        }
        currentSubtitle = dialogue.originalText
        currentTranslation = dialogue.translatedText
        currentWords = dialogue.words
    }
            
    // remove player to clean memory
    func cleanup() {
        if let boundaryObserver { player?.removeTimeObserver(boundaryObserver) }
        if let periodicObserver { player?.removeTimeObserver(periodicObserver) }
        player?.pause()
        player = nil
    }
    
    //---audio recording functions
    
    func startRecording() {
        //create recording session, use mic
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(.playAndRecord, mode: .default) //allow play and rec
            try session.setActive(true)
        } catch{return} //no recording if fail
        
        //voice recoding settings - AAC format, CD quality, 1 voice rec at a time
        let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1
            ]
        
        do{
            //create recorder, start recording
            audioRecorder = try AVAudioRecorder(url: audioRecordingURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true //to read mic loudness
            audioRecorder?.record()
            
            recordingState = .recording
            audioLevels = [] //clear old waveform data
            
            //start timer to record loudness - to convert in waveform bars
            audioLevelsTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                //prevents memory leak
                guard let self,
                      let recorder = self.audioRecorder,
                      recorder.isRecording else { return }
                
                recorder.updateMeters() //refresh loudness reading
                
                // averagePower returns decibels: -160 (silence) to 0 (max loud)
                // We normalize it to 0.0 - 1.0 so we can use it as bar height
                let power = recorder.averagePower(forChannel: 0)
                
                // Why +50 and /50?
                // Typical speech is around -50dB to 0dB.
                // So: -50dB → (−50+50)/50 = 0.0 (short bar)
                //      0dB → (0+50)/50   = 1.0 (tall bar)
                //    -25dB → (−25+50)/50 = 0.5 (medium bar)
                let normalized = CGFloat(max(0, (power + 50) / 50))
                
                self.audioLevels.append(normalized)
                
                // Cap at 100 bars so the view doesn't get too wide.
                // removeFirst() drops the oldest bar, creating a scrolling effect.
                
//                if self.audioLevels.count > 100 { self.audioLevels.removeFirst() }
            }
        } catch { return }
    }

    func stopRecording() {
        audioLevelsTimer?.invalidate()    // stop the timer from firing
        audioLevelsTimer = nil
        audioRecorder?.stop()       // stop the actual recording
        audioRecorder = nil
        recordingState = .finished
        
        //expected = curernts og text
        guard let expectedText = currentDialogue?.originalText else { return }
            
        SpeechEvaluator.evaluate(
            recordingURL: audioRecordingURL,
            expected: expectedText,
            locale: video.language.speechLocale) { [weak self] score in
            guard let self else { return }
            self.currentDialogueScore = score // Update current dialogue score
            
            // Store it by dialogue index so we can average later
            if let score {
                self.perDialogueScores[self.currentDialogueIndex] = score
            }
        }
    }

    func resetRecording() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        audioPlayer?.stop()
        audioPlayer = nil
        
        audioLevelsTimer?.invalidate()
        audioLevelsTimer = nil
        audioRecorder?.stop()
        audioRecorder = nil
        
        recordingState = .idle
        audioLevels = [] //clear waveform bars
        playbackProgress = 0
        isPlayingBack = false
        currentDialogueScore = nil //reset current score
    }

    func startPlayback() {
        // If player exists, resume from current position
        if let player = audioPlayer {
            player.play()
            isPlayingBack = true
            startPlaybackTimer()
            return
        }
        
        // First time playing — create the player
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecordingURL)
            audioPlayer?.prepareToPlay()
            
            // dragged - play rec from dragged position
            if playbackProgress > 0, let player = audioPlayer {
                player.currentTime = Double(playbackProgress) * player.duration
            }
            
            audioPlayer?.play()
            isPlayingBack = true
            startPlaybackTimer()
        } catch { return }
    }

    func stopPlayback() {
        audioPlayer?.pause()   // if rec exist, pause it
        isPlayingBack = false
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    func seekPlayback(to progress: CGFloat) {
        playbackProgress = progress
        // If already playing, seek the audio too
        if let player = audioPlayer {
            player.currentTime = Double(progress) * player.duration
        }
    }
    
    private func startPlaybackTimer() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self, let player = self.audioPlayer else { return }
            if player.isPlaying {
                self.playbackProgress = CGFloat(player.currentTime / player.duration)
            } else {
                // Playback finished naturally — reset to idle
                self.isPlayingBack = false
                self.playbackProgress = 0
                self.playbackTimer?.invalidate()
                self.playbackTimer = nil
            }
        }
    }
    
    func restartVideo() { //replays from dialogue 0
        resetRecording()
        perDialogueScores = [:]
        currentDialogueIndex = 0
        updateSubtitles()
        player?.seek(to: .zero) { [weak self] _ in
            self?.play()
        }
    }
    
    // writing mode:
    
    func addPointToStroke(_ point: CGPoint) {
        currentStroke.append(point)
    }

    func finishStroke() {
        // when user lifts finger, save current stroke and start fresh
        if !currentStroke.isEmpty {
            strokes.append(currentStroke)
            currentStroke = []
        }
    }
    
    func skipToNextWord(){
        guard let dialogue = currentDialogue else { return } //check if dialogue exists
        
        if currentWordsIndex < dialogue.words.count - 1 { //if theres words left
            currentWordsIndex += 1
            clearCanvas()
        } else {
            currentWordsIndex = 0
            skipToNextDialogue() //checking
        }
    }
    
    func clearCanvas() {
        strokes = []
        currentStroke = []
    }
}
