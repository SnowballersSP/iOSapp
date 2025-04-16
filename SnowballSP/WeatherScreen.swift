import SwiftUI

struct WeatherScreen: View {
    @State private var forecast: [WeatherDay] = []

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("7-Day Forecast")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)

                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(forecast) { day in
                                WeatherCard(day: day)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    Spacer()

                    NavigationLink(destination: TimerArea()) {
                        Text("Set Scheduled Clean")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .onAppear {
                fetchWeatherData()
            }
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
                    let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
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
                    }
                } catch {
                    print("❌ Decoding error: \(error)")
                }
            } else if let error = error {
                print("❌ Network error: \(error)")
            }
        }.resume()
    }

    func temperatureColor(_ temperature: Double) -> Color {
        switch temperature {
        case ..<40: return .blue
        case 40..<60: return .green
        case 60..<80: return .yellow
        default: return .red
        }
    }

    func getWeatherSymbol(for description: String) -> String {
        let lower = description.lowercased()
        if lower.contains("cloud") { return "☁️" }
        if lower.contains("rain")  { return "🌧" }
        if lower.contains("snow")  { return "❄️" }
        if lower.contains("sun")   { return "☀️" }
        return "🌤"
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

struct WeatherCard: View {
    let day: WeatherDay

    var body: some View {
        HStack(spacing: 16) {
            Text(day.symbol)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(day.day)
                    .font(.headline)
                Text(day.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("\(Int(day.temperature))°F")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(temperatureColor(day.temperature))
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(16)
        .shadow(radius: 5)
    }

    func temperatureColor(_ temperature: Double) -> Color {
        switch temperature {
        case ..<40: return .blue
        case 40..<60: return .green
        case 60..<80: return .yellow
        default: return .red
        }
    }
}

// Blur background effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
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
