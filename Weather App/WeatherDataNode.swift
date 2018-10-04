//
//  WeatherDataNode.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

class WeatherDataNode: Decodable {
    var dt: Int?
    var dt_txt: String?
    var main: MainWeatherData?
    var weather: [WeatherData]?
}
