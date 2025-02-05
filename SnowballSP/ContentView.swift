import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack { // Ensure only HomePage has NavigationStack
            VStack(spacing: 20) {
                Text("Home Page")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                VStack(spacing: 30) {
                    NavigationRow(imageName: "scan_area", title: "Scan Area", destination: ScanAreaPage())
                    NavigationRow(imageName: "deploy", title: "Deploy", destination: DeployPage())
                    NavigationRow(imageName: "timer", title: "Timer", destination: TimerPage())
                    NavigationRow(imageName: "statistics", title: "Statistics", destination: StatisticsPage())
                }

                Spacer()
            }
            .padding()
        }
    }
}

// Reusable component for navigation
struct NavigationRow<Destination: View>: View {
    var imageName: String
    var title: String
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)

                Text(title)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// Preview
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
