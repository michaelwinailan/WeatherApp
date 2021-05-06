//
//  ViewController.swift
//  WeatherApp
//
//  Created by Michael Winailan on 4/22/21.
//

import UIKit
import SDWebImage

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: ResultsTableViewController())
    var forecastModel:ForecastModel = ForecastModel()
    
    var sampleCities:[String:[Double]] = [:]
    var forecast:Forecast? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        forecastModel.forecastVC = self
        forecastModel.loadCities()
        
        // This is the initial city location, modify it if you like!
        forecastModel.loadForecast(latitude: 37.7749, longitude: -122.4194, cityName: "San Francisco, US")
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.placeholder = "Search city"
    }
}

// MARK: - Search Delegate Functions

extension ForecastViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let resultsViewController = searchController.searchResultsController as? ResultsTableViewController
        
        if let resultsViewController = resultsViewController {
            DispatchQueue.global().async {
                resultsViewController.coordinatesByCities = self.sampleCities.filter{$0.key.hasPrefix(text.capitalized)}
                DispatchQueue.main.async {
                    // Data has been filtered, now update the UI!
                    resultsViewController.tableView.reloadData()
                    resultsViewController.forecastVC = self
                }
            }
        }
    }
}

// MARK: - TableView Delegate Functions

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.weatherTableView.dequeueReusableCell(withIdentifier: "weatherTableViewCell")
        
        if forecast == nil {
            return cell!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let dayLabel = cell?.viewWithTag(1) as! UILabel
        dayLabel.text = dateFormatter.string(from: forecast!.daily[indexPath.row].dt)
        
        let weatherImageView = cell?.viewWithTag(2) as! UIImageView
        var weatherIconURL: URL {
            let urlString = "http://openweathermap.org/img/wn/\(forecast!.daily[indexPath.row].weather[0].icon)@2x.png"
            return URL(string: urlString)!
        }
        weatherImageView.sd_setImage(with: URL(string: "https://openweathermap.org/img/wn/\(forecast!.daily[indexPath.row].weather[0].icon)@2x.png"), placeholderImage: UIImage(named: "Placeholder"), completed: nil)
        
        let weatherDescriptionLabel = cell?.viewWithTag(3) as! UILabel
        let weatherDescription = forecast!.daily[indexPath.row].weather[0].description
        weatherDescriptionLabel.text = "\(weatherDescription.capitalized)\n\(forecast!.daily[indexPath.row].temp.day)°C"
        
        return cell!
    }
}
