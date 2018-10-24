//
//  ForecastTableViewController.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
}

class ForecastTableViewController: UITableViewController {
    var weather: (String, [Weather])?;
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nod = weather {
            return nod.1.count;
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell");
        if let forecastCell = cell as? ForecastTableViewCell {
            if let weather = self.weather?.1[indexPath.row] {
                forecastCell.iconImage.image = UIImage(named: weather.icon);
                forecastCell.upperLabel.text = weather.desc + "\t\t" +  String(weather.temp) + " °C";
                forecastCell.lowerLabel.text = weather.timestamp;
            }
        }
        return cell!;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let city = weather?.0, city != DataHandler.state.currentCity {
            updateView();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateView();
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
                    self.tableView.reloadData();
                })
            } else {
                self.weather = nil;
                DispatchQueue.main.async(execute: {() in
                    self.tableView.reloadData();
                });
                
                self.present(DataHandler.alertUser(), animated: true, completion: nil);
            }
        }
        );
    }
}
