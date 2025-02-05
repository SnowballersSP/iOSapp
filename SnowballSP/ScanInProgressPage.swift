import SwiftUI

struct ScanInProgressPage: View {
    var body: some View {
        VStack {
            Text("Scanning in Progress...")
                .font(.largeTitle)
                .padding()

            ProgressView()
                .scaleEffect(2)
                .padding()

            Spacer()
        }
    }
}

// Preview
struct ScanInProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanInProgressPage()
    }
}
