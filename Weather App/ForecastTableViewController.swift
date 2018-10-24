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
    var activityIndicator = UIActivityIndicatorView(style: .gray);

    
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
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(activityIndicator);
        
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
            ]);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        activityIndicator.startAnimating();
        
        DataHandler.fetchCurrent(handler: { (incoming: (String, [Weather])?)  in
            if let inc = incoming {
                self.weather = inc;
                DispatchQueue.main.async(execute: {() in
                    self.tableView.reloadData();
                    self.activityIndicator.stopAnimating();
                })
            } else {
                self.weather = nil;
                DispatchQueue.main.async(execute: {() in
                    self.tableView.reloadData();
                    self.present(DataHandler.alertUser(), animated: true, completion: nil);
                    self.activityIndicator.stopAnimating();
                });
            }
        }
        );
    }
}
