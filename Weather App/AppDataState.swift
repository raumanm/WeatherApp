//
//  AppDataState.swift
//  Weather App
//
//  Created by Mikko Rauman on 11/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import Foundation

struct Weather {
    var timestamp: String;
    var description: String;
    var icon: String;
    var temp: Double;
}

class AppDataState: NSObject, NSCoding {
    var currentCity = "Tampere";
    var weatherData = [String : [Weather]]();
    var locales: [String] = ["Tampere", "Turku", "London", "Stockholm"];
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(weatherData, forKey: "weatherData");
        aCoder.encode(locales, forKey: "locales");
        aCoder.encode(currentCity, forKey: "currentCity");
    }
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let data = aDecoder.decodeObject(forKey: "weatherData") as? [String : [Weather]] {
            weatherData = data;
        }
    }
}
