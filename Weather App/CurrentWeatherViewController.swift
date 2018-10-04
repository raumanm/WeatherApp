//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//
import UIKit

class CurrentWeatherViewController: UIViewController {
    var uri = "https://api.openweathermap.org/data/2.5/weather?q=Tampere,fi&units=metric&APPID=";
    var weather: WeatherDataNode?;
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DataHandler.fetchUrl(uri: uri, handler: doneFetching);
        currentImage.isHidden = true;
        locLabel.text! = ""
        tempLabel.text! = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        do {
            let attempt = try JSONDecoder().decode(WeatherDataNode.self, from: data!);
            self.weather = attempt;
            
            // Execute stuff in UI thread
            DispatchQueue.main.async(execute: {() in
                self.currentImage.image = UIImage(named: self.weather!.weather!.first!.icon!);
                self.locLabel.text = self.weather!.name!;
                self.tempLabel.text = String(self.weather!.main!.temp!) + " °C"
                self.currentImage.isHidden = false;
            })
        } catch {
            NSLog("Error!!!!");
        }
    }
}

