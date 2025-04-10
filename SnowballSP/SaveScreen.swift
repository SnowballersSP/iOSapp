import SwiftUI

struct SaveScreen: View {
    @State private var areaName: String = ""
    @State private var isSaved: Bool = false
    @State private var shouldNavigateHome = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Scan Complete ✅")
                .font(.largeTitle)
                .padding(.top, 40)

            Image("classroom")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Text("Name this scanned area:")
                .font(.headline)

            TextField("Enter area name", text: $areaName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disableAutocorrection(true)

            Button(action: {
                if !areaName.isEmpty {
                    saveArea(name: areaName)
                    isSaved = true
                }
            }) {
                Text("Save")
                    .frame(width: 150, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if isSaved {
                Text("✅ '\(areaName)' has been saved!")
                    .foregroundColor(.green)
                    .font(.subheadline)
                    .padding(.top, 10)
            }

            Spacer()
            NavigationLink(destination: HomePage(), isActive: $shouldNavigateHome) {
                            EmptyView()
                        }
        }
        .padding()
    }

    private func saveArea(name: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }

           //var savedAreas = UserDefaults.standard.stringArray(forKey: "customAreas") ?? []
        let defaults = UserDefaults.standard
        guard let currentUser = defaults.string(forKey: "loggedInUser") else { return }
        var savedAreas = defaults.stringArray(forKey: "\(currentUser)_customAreas") ?? []
        savedAreas.append(name)
        defaults.set(savedAreas, forKey: "\(currentUser)_customAreas")

        savedAreas.append(name)
           UserDefaults.standard.set(savedAreas, forKey: "customAreas")

           isSaved = true

           DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
               shouldNavigateHome = true
           }
    }

}

// Preview
struct SaveScreen_Previews: PreviewProvider {
    static var previews: some View {
        SaveScreen()
    }
}
