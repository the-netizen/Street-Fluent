import SwiftUI

struct WritingCanvas: View {
    var viewModel: VideoViewModel
    
    var body: some View {
        Canvas { context, size in
            
            for stroke in viewModel.strokes {
                drawStroke(stroke, in: &context) //draw completed strokes
            }

            if !viewModel.currentStroke.isEmpty {
                drawStroke(viewModel.currentStroke, in: &context) //draw current strokes
            }
        }
        //capture finger movement
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Each movement adds a point to the current stroke
                    viewModel.addPointToStroke(value.location)
                }
                .onEnded { _ in
                    // Finger lifted — finalize this stroke
                    viewModel.finishStroke()
                }
        )
    }
    
    // Draws a single stroke as a smooth path
    private func drawStroke(_ points: [CGPoint], in context: inout GraphicsContext) {
        guard points.count > 1 else { return }
        
        var path = Path()
        path.move(to: points[0])
        
        // Connect each point with a line
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        // Stroke style:rounded ends, 3pt thick..
        context.stroke(
            path,
            with: .color(Color(.systemBackground)),
            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
        )
    }
}

#Preview {
    ZStack {
        Color.road
        WritingCanvas(viewModel: VideoViewModel(video: SampleData.videos.first!))
    }
    .frame(height: 300)
}
