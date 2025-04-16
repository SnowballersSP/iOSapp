import SwiftUI

struct UseSaltPage: View {
    var body: some View {
        VStack {
            Text("Would you like to use the salt dispenser?")
                .font(.title)
                .padding()

            HStack(spacing: 20) {
                NavigationLink(destination: ScanRunningPage()) {
                    UseSaltButton(title: "Yes")
                }
                NavigationLink(destination: ScanRunningPage()) {
                    NotUseSaltButton(title: "No")
                }
            }
            .padding()

            Spacer()
        }
    }
}

// Custom Button Component
struct UseSaltButton: View {
    var title: String

    var body: some View {
        Text(title)
            .frame(width: 100, height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
struct NotUseSaltButton: View {
    var title: String

    var body: some View {
        Text(title)
            .frame(width: 100, height: 50)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}


// Preview
struct UseSaltPage_Previews: PreviewProvider {
    static var previews: some View {
        UseSaltPage()
    }
}
