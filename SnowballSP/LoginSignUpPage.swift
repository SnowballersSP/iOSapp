import SwiftUI

struct LoginSignupPage: View {
    @State private var isLoginMode = true
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = "" // For signup only
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 5)
                Text(isLoginMode ? "Login" : "Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 1)

                Picker(selection: $isLoginMode, label: Text("Mode")) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 40)
                .padding(.top, 5)

                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)

                if !isLoginMode {
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }

                Button(action: handleAuth) {
                    Text(isLoginMode ? "Login" : "Sign Up")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                autoLoginCheck()
            }
        }
    }

    //  Handle Login & Signup
    private func handleAuth() {
        let defaults = UserDefaults.standard
        
        if isLoginMode {
            // Login Logic
            if let savedPassword = defaults.string(forKey: username.lowercased()) {
                if savedPassword == password {
                    defaults.set(username, forKey: "loggedInUser")
                    navigateToHome()
                } else {
                    alertMessage = "Incorrect password."
                    showAlert = true
                }
            } else {
                alertMessage = "Username not found."
                showAlert = true
            }
        } else {
            // Signup Logic
            if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                alertMessage = "All fields are required."
                showAlert = true
                return
            }

            if password != confirmPassword {
                alertMessage = "Passwords do not match."
                showAlert = true
                return
            }

            if defaults.string(forKey: username.lowercased()) != nil {
                alertMessage = "Username already exists."
                showAlert = true
                return
            }

            // Save new user
            defaults.set(password, forKey: username.lowercased())
            defaults.set(username, forKey: "loggedInUser")
            navigateToHome()
        }
    }

    //  Check Auto-Login
    private func autoLoginCheck() {
        let defaults = UserDefaults.standard
        if let loggedInUser = defaults.string(forKey: "loggedInUser") {
            username = loggedInUser
            navigateToHome()
        }
    }

    //  Navigate to HomePage
    private func navigateToHome() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            withAnimation {
                window.rootViewController = UIHostingController(rootView: HomePage())
                window.makeKeyAndVisible()
            }
        }
    }

}

//  Preview
struct LoginSignupPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupPage()
    }
}
