//
//  WeatherManager.swift
//  Clima
//
//  Created by Enrique Gongora on 5/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=565ae3a18142c28d33faa41cc7c2ed73&units=imperial"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // Step 1: Create a URL
        if let url = URL(string: urlString) {
            
            // Step 2: Create a URLSession
            let session = URLSession(configuration: .default)
            
            // Step 3: Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let data = data {
                    self.parseJSON(weatherData: data)
                }
            }
            
            // Step 4: Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
        } catch {
            print(error)
        }
    }
}
