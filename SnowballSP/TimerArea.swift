import SwiftUI

struct TimerArea: View {
    var body: some View {
        VStack {
            Text("Select area for timer:")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Spacer()

            // Buttons for Areas
            VStack(spacing: 20) {
                TimerNavigationButton(title: "Front Garage")
                TimerNavigationButton(title: "Front Patio")
                TimerNavigationButton(title: "Back Patio")
                TimerNavigationButton(title: "Sidewalk")
            }
            
            Spacer()

            // View Scheduled Cleanings Button
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
