import SwiftUI

struct StatisticsPage: View {
    var body: some View {
        VStack {
            Text("Select Option")
                .font(.title)
                .padding()

            Spacer()

            VStack(spacing: 20) {
                NavigationLink(destination: UsageScreen()) {
                    Text("Usage")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: WeatherScreen()) {
                    Text("Weather")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
    }
}

struct StatisticsPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StatisticsPage()
        }
    }
}
