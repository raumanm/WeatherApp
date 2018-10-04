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
    var weather: CurrentWeatherRequest?;
    
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
        let resstr = String(data: data!, encoding: String.Encoding.utf8);
        print(resstr!);
        

        do {
            let attempt = try JSONDecoder().decode(CurrentWeatherRequest.self, from: data!);
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

/*
 
{"coord":{"lon":23.76,"lat":61.5},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":2.88,"pressure":1014,"humidity":60,"temp_min":2,"temp_max":4},"visibility":10000,"wind":{"speed":2.1,"deg":260},"clouds":{"all":75},"dt":1538666400,"sys":{"type":1,"id":5045,"message":0.0025,"country":"FI","sunrise":1538628022,"sunset":1538667920},"id":634964,"name":"Tampere","cod":200}
 
 */

