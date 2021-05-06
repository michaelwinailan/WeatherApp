//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Michael Winailan on 4/22/21.
//

import Foundation

struct Forecast: Codable {
    struct Daily: Codable {
        let dt: Date
        struct Temp: Codable {
            let day: Double
        }
        let temp: Temp
        struct Weather: Codable {
            let icon: String
            let description: String
        }
        let weather: [Weather]
    }
    let daily: [Daily]
}
