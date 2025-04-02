import SwiftUI

struct ScanInProgressPage: View {
    @State private var stage: Int = 0 // Controls which image is displayed
    @State private var progress: CGFloat = 0.0 // Progress bar value
    @State private var navigateToSave = false
    @State private var progressText: Int = 0 // For smooth % update
    
    var body: some View {
        VStack {
            Text("Scanning in Progress...")
                .font(.largeTitle)
                .padding()
            
            // Image Display Logic
            ZStack {
                if stage == 0 {
                    ProgressView()
                        .scaleEffect(2)
                } else if stage == 1 {
                    Image("driveway")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                } else if stage == 2 {
                    Image("classroom")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }
            }
            .padding()
            
            // Progress Bar + Percentage
            VStack {
                Text("\(progressText)%") // Live updating percentage
                    .font(.headline)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 10)
                            .opacity(0.3)
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .frame(width: geometry.size.width * progress, height: 10)
                            .foregroundColor(.green)
                            .animation(.linear(duration: 0.1), value: progress)
                    }
                }
                .frame(height: 10)
                .padding(.horizontal)
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            startSequence()
        }
        .navigationDestination(isPresented: $navigateToSave) {
            SaveScreen() // Replace with actual save screen
        }
    }
    
    private func startSequence() {
        var elapsedTime: Double = 0.0
        let totalDuration: Double = 6.0 // Total scan time before navigating

        // Timer to update progress bar and percentage smoothly
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            elapsedTime += 0.1
            progress = min(elapsedTime / totalDuration, 1.0) // Ensures max is 1.0
            progressText = min(Int(progress * 100), 100) // Caps at 100%

            // Change images at specific times
            if elapsedTime >= 2.0 && stage == 0 {
                stage = 1 // Show driveway
            }
            if elapsedTime >= 4.0 && stage == 1 {
                stage = 2 // Show classroom
            }

            // Stop timer when progress hits 100%
            if elapsedTime >= totalDuration {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigateToSave = true // Navigate to Save Screen
                }
            }
        }
    }

}

// Preview
struct ScanInProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanInProgressPage()
    }
}
