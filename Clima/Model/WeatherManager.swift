//
//  WeatherManager.swift
//  Clima
//
//  Created by Enrique Gongora on 5/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=565ae3a18142c28d33faa41cc7c2ed73&units=imperial"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
    }
}
