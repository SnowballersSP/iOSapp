import SwiftUI

struct WeatherScreen: View {
    @State private var forecast: [WeatherDay] = []
    
    var body: some View {
        VStack {
            Text("Weather Forecast")
                .font(.title)
                .padding()
            
            List(forecast) { day in
                HStack {
                    Text(day.symbol) // Weather symbol
                    Text("\(day.day): \(day.description) \(Int(day.temperature))°F")
                        .foregroundColor(temperatureColor(day.temperature))
                }
            }
            .onAppear {
                fetchWeatherData()
            }

            Spacer()

            NavigationLink(destination: TimerArea()) {
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
        let apiKey = "b9a7d49920a14256b2314145250204"
        let location = "Washington,DC"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(location)&days=7&aqi=no&alerts=no"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    // Print raw API response
                    if let rawResponse = String(data: data, encoding: .utf8) {
                        print("Raw API Response: \(rawResponse)")
                    }

                    let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    
                    // Debugging: Print count of received forecast days
                    print("Forecast days received: \(decodedData.forecast.forecastday.count)")

                    DispatchQueue.main.async {
                        self.forecast = decodedData.forecast.forecastday.map { day in
                            let temp = day.day.avgtemp_f
                            return WeatherDay(
                                day: formatDate(day.date),
                                description: day.day.condition.text,
                                temperature: temp,
                                symbol: getWeatherSymbol(for: day.day.condition.text)
                            )
                        }

                        // Debugging: Print final mapped forecast data
                        print("Mapped forecast data: \(self.forecast)")
                    }
                } catch {
                    print("Error decoding weather data: \(error)")
                }
            } else if let error = error {
                print("Network request failed: \(error)")
            }
        }.resume()
    }


    func temperatureColor(_ temperature: Double) -> Color {
        switch temperature {
        case ..<40:
            return .blue
        case 40..<60:
            return .green
        case 60..<80:
            return .yellow
        default:
            return .red
        }
    }

    func getWeatherSymbol(for description: String) -> String {
        let lowercased = description.lowercased()
        if lowercased.contains("cloud") {
            return "☁️"
        } else if lowercased.contains("rain") {
            return "🌧"
        } else if lowercased.contains("snow") {
            return "❄️"
        } else if lowercased.contains("sun") {
            return "☀️"
        } else {
            return "🌤"
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        return dateString
    }
}

// Models for Decoding API Response
struct WeatherResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
}

struct Day: Codable {
    let avgtemp_f: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
}

// Model for Displaying in SwiftUI
struct WeatherDay: Identifiable {
    let id = UUID()
    let day: String
    let description: String
    let temperature: Double
    let symbol: String
}

// Preview
struct WeatherScreen_Previews: PreviewProvider {
    static var previews: some View {
        WeatherScreen()
    }
}
