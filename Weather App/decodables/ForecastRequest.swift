//
//  ForecastRequest.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

class ForeCastRequest: Decodable {
    var cod: String?
    var message: Double?
    var cnt: Int?
    var list: [WeatherDataNode]?
    
}
