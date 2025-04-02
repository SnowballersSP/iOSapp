import SwiftUI

struct ScanAreaPage: View {
    var body: some View {
        VStack(spacing: 20) { 
            Image("turtlebot")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 250)
                .padding()

            // Instructions Text
            Text("Instructions: Please place the SnowBaller in the corner of your desired area")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            // Scan New Area Button - Positioned Below Instructions
            NavigationLink(destination: ScanInProgressPage()) {
                Text("Scan New Area")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}

// Preview
struct ScanAreaPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanAreaPage()
    }
}
