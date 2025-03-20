import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                VStack(spacing: 20) {
                    Text("SnowBaller")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    VStack(spacing: 30) {
                        NavigationRow(imageName: "scan_area", title: "Scan Area", destination: ScanAreaPage())
                        NavigationRow(imageName: "deploy", title: "Deploy", destination: DeployPage())
                        NavigationRow(imageName: "timer", title: "Timer", destination: TimerArea())
                        NavigationRow(imageName: "statistics", title: "Statistics", destination: StatisticsPage())
                    }

                    Spacer()
                }
                .padding()

                // Logout Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: logout) {
                            Image(systemName: "figure.walk.departure") //  icon
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
        }
    }

    // Logout function
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            withAnimation {
                window.rootViewController = UIHostingController(rootView: LoginSignupPage())
                window.makeKeyAndVisible()
            }
        }
    }
}

// Reusable Navigation Row
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
