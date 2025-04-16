import SwiftUI

struct CongratsScreen: View {
    var body: some View {
        VStack {
            Text("Clean Completed")
                .font(.largeTitle)
                .foregroundColor(.green)
                .bold()
                .padding()

            Spacer()

            LottieView(filename: "congrats")
                            .frame(width: 500, height: 500)
                            .padding()

            Spacer()
            NavigationLink(destination: HomePage()) {
                            Text("Home")
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
        }
        .navigationBarBackButtonHidden(true) // Hide back button
    }
}
