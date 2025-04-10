import SwiftUI

struct DeployPage: View {
    @State private var customAreas: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Choose Area to Clean")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if customAreas.isEmpty {
                    VStack(spacing: 20) {
                        Text("You haven't saved any areas yet.")
                            .font(.headline)
                            .foregroundColor(.gray)

                        NavigationLink(destination: ScanAreaPage()) {
                            Text("Scan and Save a New Area")
                                .frame(width: 250, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 50)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(customAreas, id: \.self) { area in
                                NavigationLink(destination: UseSaltPage()) {
                                    DeployButton(title: area)
                                }
                            }
                        }
                        .padding()
                    }
                }

                Spacer()
            }
            .onAppear {
                let defaults = UserDefaults.standard
                if let currentUser = defaults.string(forKey: "loggedInUser") {
                    customAreas = defaults.stringArray(forKey: "\(currentUser)_customAreas") ?? []
                }
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
