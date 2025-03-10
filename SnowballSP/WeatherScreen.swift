//
//  WeatherScreen.swift
//  SnowballSP
//
//  Created by Brianna John on 2/20/25.
//

import SwiftUI

struct WeatherScreen: View {
    @State private var forecast: [String] = ["Loading..."]

    var body: some View {
        VStack {
            Text("Weather Forecast")
                .font(.title)
                .padding()

            List(forecast, id: \.self) { day in
                Text(day)
            }
            .onAppear {
                fetchWeatherData()
            }

            Spacer()

            NavigationLink(destination: SelectDayPage()) {
                Text("Set Scheduled Clean")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    func fetchWeatherData() {
        // Placeholder: Replace this with an actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.forecast = [
                "Monday: Snow 30°F",
                "Tuesday: Clear 32°F",
                "Wednesday: Snow 28°F",
                "Thursday: Cloudy 31°F",
                "Friday: Sunny 35°F",
                "Saturday: Snow 27°F",
                "Sunday: Partly Cloudy 30°F"
            ]
        }
    }
}

struct WeatherScreen_Previews: PreviewProvider {
    static var previews: some View {
        WeatherScreen()
    }
}
