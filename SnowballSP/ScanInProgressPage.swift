import SwiftUI
//this is for first scan
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

            // Back Button to Scan Area Page
            NavigationLink(destination: ScanAreaPage()) {
                Text("Back")
                    .frame(width: 200, height: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

// Preview
struct ScanInProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanInProgressPage()
    }
}
