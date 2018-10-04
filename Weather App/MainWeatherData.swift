//
//  WeatherData.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

struct MainWeatherData: Decodable {
    var temp: Double?
    var pressure: Int?
    var humidity: Int?
}
