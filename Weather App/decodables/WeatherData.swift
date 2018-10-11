//
//  WeatherData.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

struct WeatherData: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
