//
//  todaysinsightsweather.swift
//  CosmicRoots
//
//  Created by Esra Ataç on 5.10.2025.
//
import Foundation

struct OpenMeteoResponse: Codable {
    struct Current: Codable {
        let temperature: Double
        let weathercode: Int
    }
    let current_weather: Current
}

@MainActor
class WeatherManager: ObservableObject {
    @Published var temperature: Double?
    @Published var condition: String?
    @Published var icon: String?
    @Published var errorMessage: String?

    func fetchWeather(lat: Double, lon: Double) async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            let cw = decoded.current_weather

            temperature = cw.temperature

            // Koşula göre metin + ikon
            switch cw.weathercode {
            case 0:
                condition = "Clear"
                icon = "sun.max.fill"
            case 1,2,3:
                condition = "Partly Cloudy"
                icon = "cloud.sun.fill"
            case 45,48:
                condition = "Fog"
                icon = "cloud.fog.fill"
            case 51,53,55:
                condition = "Drizzle"
                icon = "cloud.drizzle.fill"
            case 61,63,65:
                condition = "Rain"
                icon = "cloud.rain.fill"
            case 71,73,75:
                condition = "Snow"
                icon = "snow"
            case 80,81,82:
                condition = "Rain Showers"
                icon = "cloud.rain.fill"
            case 95:
                condition = "Thunderstorm"
                icon = "cloud.bolt.rain.fill"
            default:
                condition = "Unknown"
                icon = "questionmark"
            }

            errorMessage = nil
        } catch {
            errorMessage = "Fetch failed: \(error.localizedDescription)"
        }
    }
}
