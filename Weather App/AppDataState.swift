//
//  AppDataState.swift
//  Weather App
//
//  Created by Mikko Rauman on 11/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding {
    var timestamp: String = "";
    var desc: String = "";
    var icon: String = "";
    var temp: Double = 0.0;
    
    init(timestamp: String, desc: String, icon: String, temp: Double) {
        self.timestamp = timestamp;
        self.desc = desc;
        self.icon = icon;
        self.temp = temp;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(timestamp, forKey: "timestamp");
        aCoder.encode(desc, forKey: "description");
        aCoder.encode(icon, forKey: "icon");
        aCoder.encode(temp, forKey: "temp");
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let timestamp = aDecoder.decodeObject(forKey: "timestamp") as? String {
            self.timestamp = timestamp;
        } else {
            NSLog("failed ts");
        }
        
        if let desc = aDecoder.decodeObject(forKey: "description") as? String {
            self.desc = desc;
        } else {
            NSLog("failed description");
        }
        
        if let icon = aDecoder.decodeObject(forKey: "icon") as? String {
            self.icon = icon;
        } else {
            NSLog("failed icon");
        }
        
        self.temp = aDecoder.decodeDouble(forKey: "temp");
    }
}

class AppDataState: NSObject, NSCoding {
    var currentCity = "Tampere";
    var weatherData = [String : [Weather]]();
    var locales: [String] = ["Tampere", "Turku", "London", "Stockholm"];
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currentCity, forKey: "currentCity");
        aCoder.encode(locales, forKey: "locales");
        aCoder.encode(weatherData, forKey: "weatherData");
    }
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let data = aDecoder.decodeObject(forKey: "weatherData") as? [String : [Weather]] {
            weatherData = data;
        }
    }
}
