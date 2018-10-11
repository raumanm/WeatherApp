//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//
import UIKit

class CurrentWeatherViewController: UIViewController {
    //var uri = "https://api.openweathermap.org/data/2.5/weather?q=Tampere,fi&units=metric&APPID=";
    //var weather: CurrentWeatherRequest?;
    var weather: (String, [Weather])?;
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentImage.isHidden = true;
        locLabel.text! = ""
        tempLabel.text! = ""
        
        updateView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let city = weather?.0, city != DataHandler.state.currentCity {
            updateView();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        DataHandler.fetchCurrent(handler: { (incoming: (String, [Weather])?)  in
            if let inc = incoming {
                self.weather = inc;
                DispatchQueue.main.async(execute: {() in
                    self.currentImage.image = UIImage(named: self.weather!.1.first!.icon);
                    self.locLabel.text = self.weather!.0;
                    self.tempLabel.text = String(round(self.weather!.1.first!.temp*100.0)/100.0) + " °C"
                    self.currentImage.isHidden = false;
                })
            } else {
                self.weather = nil;
                DispatchQueue.main.async(execute: {() in
                    self.currentImage.isHidden = true;
                    self.locLabel.text! = ""
                    self.tempLabel.text! = ""
                });
                self.present(DataHandler.alertUser(), animated: true, completion: nil);
            }
        }
        );
    }
}
