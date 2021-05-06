//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Michael Winailan on 4/22/21.
//

import UIKit

class ForecastModel: NSObject {
    
    var forecastVC:ForecastViewController?
    
    // TODO: Plug in your API Key from OpenWeather API to start!
    let apiKey = ""
    
    func loadCities() {
        if let path = Bundle.main.path(forResource: "Cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [NSDictionary] {
                    for elem in jsonResult {
                        let cityName:String = "\(elem["name"]!), \(elem["country"]!)"
                        let latitude = (elem["lat"] as? NSString)?.doubleValue ?? 0.0
                        let longitude = (elem["lng"] as? NSString)?.doubleValue ?? 0.0
                        forecastVC?.sampleCities[cityName] = [latitude, longitude]
                    }
                }
            } catch {
                // Error
            }
        }
    }
    
    func loadForecast(latitude: Double, longitude: Double, cityName: String) {
        
        let apiService = OpenWeatherHelper.shared
        
        if forecastVC == nil {
            return
        }
        
        apiService.parseJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=current,minutely,hourly,alerts&appid=\(apiKey)",
                           dateDecodingStrategy: .secondsSince1970) { [self] (result: Result<Forecast,OpenWeatherHelper.APIError>) in
            switch result {
            case .success(let forecast):
                forecastVC!.forecast = forecast
                
                DispatchQueue.main.async { [self] in
                    forecastVC!.weatherTableView.reloadData()
                    forecastVC!.title = cityName
                }
                
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    print(errorString)
                }
            }
        }
    }
}
