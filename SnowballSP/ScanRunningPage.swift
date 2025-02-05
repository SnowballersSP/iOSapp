import SwiftUI

struct ScanRunningPage: View {
    var body: some View {
        VStack {
            Text("Scan Running...")
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
struct ScanRunningPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanRunningPage()
    }
}
