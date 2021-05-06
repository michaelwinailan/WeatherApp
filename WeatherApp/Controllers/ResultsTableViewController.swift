//
//  ResultsTableViewController.swift
//  WeatherApp
//
//  Created by Michael Winailan on 4/22/21.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    
    var forecasts:[Forecast] = []
    var coordinatesByCities:[String:[Double]] = [:]
    var filteredCities:[String] = []
    var forecastVC:ForecastViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = filteredCities[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if forecastVC == nil {
            return
        }

        let lat:Double = coordinatesByCities[filteredCities[indexPath.row]]?[0] ?? 0.0
        let long:Double = coordinatesByCities[filteredCities[indexPath.row]]?[1] ?? 0.0
        let cityName = filteredCities[indexPath.row]
    
        self.forecastVC!.searchController.dismiss(animated: true, completion: nil)
        self.forecastVC!.searchController.searchBar.searchTextField.text = ""
        self.forecastVC!.forecastModel.loadForecast(latitude: lat, longitude: long, cityName: cityName)
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCities = coordinatesByCities.keys.sorted()
        return coordinatesByCities.count
    }
}

