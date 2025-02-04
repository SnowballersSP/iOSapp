import SwiftUI
//this is for deploying
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

            // Back Button to Deploy Page
            NavigationLink(destination: DeployPage()) {
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
struct ScanRunningPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanRunningPage()
    }
}
