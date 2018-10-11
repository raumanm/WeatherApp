//
//  DataFetcher.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import Foundation
import UIKit

class DataHandler {
    static var state = AppDataState();
    static let req = "https://api.openweathermap.org/data/2.5/forecast?q=Tampere,fi&units=metric&APPID=";
    
    static func fetchCurrent(handler: @escaping ((String,[Weather])?)->Void) -> Void {
        let city = state.currentCity;
        NSLog("fetching current: \(city)");
        if (state.weatherData.keys.contains(city)) {
            if let data = state.weatherData[city] {
                NSLog("\(city) found in cache.");
                handler((city, data));
            } 
        } else {
            NSLog("\(city) not found in cache, requesting.");
            fetchUrl(uri: "https://api.openweathermap.org/data/2.5/forecast?q=" + city + "&units=metric&APPID=",
                     handler: {(data: Data?, res: URLResponse?, err: Error?) -> (Void) in
                        if let error = err {
                            NSLog("Error in requesting data: " + error.localizedDescription);
                            handler(nil);
                        } else {
                            //let resstr = String(data: data!, encoding: String.Encoding.utf8)
                            //print(resstr!);
                            
                            do {
                                let attempt = try JSONDecoder().decode(ForeCastRequest.self, from: data!);
                                //NSLog(String(describing: attempt));
                                var list = [Weather]();
                                for node in attempt.list! {
                                    list.append(Weather(
                                        timestamp: node.dt_txt!,
                                        description: node.weather!.first!.main!,
                                        icon: node.weather!.first!.icon!,
                                        temp: node.main!.temp!));
                                }
                                state.weatherData[city] = list;
                                handler((city, list));
                            } catch {
                                NSLog("ERROR");
                                handler(nil);
                            }
                        }
            })
        }
    }
    
    static func fetchUrl(uri: String, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: (uri + "71dbe8fbc30364feff60bc7f82760c5a"))
        NSLog("REQ: \(url!.absoluteString)");
        let task = session.dataTask(with: url!, completionHandler: handler);
        
        task.resume();
    }
    
    static func alertUser() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Something went wrong fetching for weather data", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil));
        
        return alert;
    }
}
