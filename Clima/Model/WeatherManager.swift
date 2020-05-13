//
//  WeatherManager.swift
//  Clima
//
//  Created by Enrique Gongora on 5/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    // MARK: - Properties
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=565ae3a18142c28d33faa41cc7c2ed73&units=imperial"
    var delegate: WeatherManagerDelegate?
    
    // MARK: - Methods
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Step 1: Create a URL
        if let url = URL(string: urlString) {
            
            // Step 2: Create a URLSession
            let session = URLSession(configuration: .default)
            
            // Step 3: Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let data = data {
                    if let weather = self.parseJSON(data) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // Step 4: Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
