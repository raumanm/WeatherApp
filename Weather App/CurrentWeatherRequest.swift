//
//  CurrentWeatherRequest.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//
class CurrentWeatherRequest: Decodable {
    var coord: Coordinate?
    var weather: [WeatherData]?
    var main: MainWeatherData?
    var dt: Int?
    var name: String?
}

