import SwiftUI

struct TimerArea: View {
    @State private var customAreas: [String] = []

    var body: some View {
        VStack {
            Text("Select area for timer:")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Spacer()

            VStack(spacing: 20) {
                ForEach(customAreas, id: \.self) { area in
                    TimerNavigationButton(title: area)
                }
                
            }

            Spacer()

            NavigationLink(destination: SavedSchedulePage()) {
                Text("View Scheduled Cleanings")
                    .frame(width: 250, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .onAppear {
            //customAreas = UserDefaults.standard.stringArray(forKey: "customAreas") ?? []
            let defaults = UserDefaults.standard
            if let currentUser = defaults.string(forKey: "loggedInUser") {
                customAreas = defaults.stringArray(forKey: "\(currentUser)_customAreas") ?? []
            }

        }
    }
}


// Reusable Button Component
struct TimerNavigationButton: View {
    var title: String
    
    var body: some View {
        NavigationLink(destination: SelectDayPage(selectedArea: title)) {
            Text(title)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}



struct TimerArea_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TimerArea() 
        }
    }
}
