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

            // Add a celebratory animation or image
            Image(systemName: "sparkles")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.yellow)
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
