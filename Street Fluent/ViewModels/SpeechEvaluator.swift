import Foundation
import Speech

enum SpeechEvaluator{
    
    static func evaluate(recordingURL: URL, expected: String, locale: String,  completion: @escaping (Int?) -> (Void)){
        //completion??: called on main thread with score, or nil if recognition failed
        
        SFSpeechRecognizer.requestAuthorization { status in
            // check if permission granted
            
//            guard status == .authorized else {
//                DispatchQueue.main.async { completion(nil) }
//                return
//            }
            
            // set up recognizer for chinese
            guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN")), recognizer.isAvailable else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // point it to voice recording
            let request = SFSpeechURLRecognitionRequest(url: recordingURL)
            request.shouldReportPartialResults = false // only give final result
            
            // run recognition
            recognizer.recognitionTask(with: request) { result, error in
                guard let result, error == nil else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                let transcribedText = result.bestTranscription.formattedString
                let score = score(transcribed: transcribedText, expected: expected)
                
                DispatchQueue.main.async { completion(score) }
                
            }//recog
        }//sfspeech
    }//evaluate
    
    static func score(transcribed: String, expected: String) -> Int {
        
        // only get chars, no whitespace/punctuations
        let clean: (String) -> String = { text in
            text.filter{
                $0.isLetter || $0.isNumber
            }
        }
        
        let cleanExpected = clean(expected)
        let cleanTranscribed = clean(transcribed)
        
        guard !cleanExpected.isEmpty else { return 0 } //if no transcript, 0
        
        var remainingTranscribed = cleanTranscribed //use copy of transcribed
        var matchedCount = 0 //count matching chars
        
        for char in cleanExpected {
            if let index = remainingTranscribed.firstIndex(of: char) {
                matchedCount += 1
                remainingTranscribed.remove(at: index) // consume this match
            }
        }
        
        return Int(Double(matchedCount) / Double(cleanExpected.count) * 100)
        
    }//score
}

