import SwiftUI

struct ScanAreaPage: View {
    var body: some View {
        NavigationView {
            VStack {
                // Space for Snowball Image
                Image("snowball_placeholder") // Replace with actual image asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()

                Spacer()

                // Scan New Area Button
                NavigationLink(destination: ScanInProgressPage()) {
                    Text("Scan New Area")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()

                // Back Button at Bottom Right
                HStack {
                    Spacer()
                    NavigationLink(destination: HomePage()) {
                        Text("Back")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

// Preview
struct ScanAreaPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanAreaPage()
    }
}
