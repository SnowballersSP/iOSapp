import SwiftUI

struct DeployPage: View {
    var body: some View {
        NavigationView {
            VStack {
                // Tab Title
                Text("Choose Area to Scan")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Scrollable List of Buttons
                ScrollView {
                    VStack(spacing: 15) {
                        NavigationLink(destination: UseSaltPage()) {
                            DeployButton(title: "Front Garage")
                        }
                        NavigationLink(destination: UseSaltPage()) {
                            DeployButton(title: "Front Patio")
                        }
                        NavigationLink(destination: UseSaltPage()) {
                            DeployButton(title: "Back Patio")
                        }
                        NavigationLink(destination: UseSaltPage()) {
                            DeployButton(title: "Sidewalk")
                        }
                    }
                    .padding()
                }

                Spacer()
            }
        }
    }
}

// Custom Button Component
struct DeployButton: View {
    var title: String

    var body: some View {
        Text(title)
            .frame(width: 250, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// Preview
struct DeployPage_Previews: PreviewProvider {
    static var previews: some View {
        DeployPage()
    }
}
