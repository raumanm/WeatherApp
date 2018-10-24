//
//  CitySelectTableViewController.swift
//  Weather App
//
//  Created by Mikko Rauman on 11/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import UIKit
import CoreLocation

class CityAddTableViewCell: UITableViewCell  {
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var addButton: UIButton!
}

class PassableUIButton: UIButton {
    var field: UITextField!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CitySelectTableViewController: UITableViewController, CLLocationManagerDelegate {
    var locales = [String]();
    var currentSelection = "";
    var lastSelection = "";
    var activityIndicator = UIActivityIndicatorView(style: .gray);
    var locationManager = CLLocationManager();
    var geoCoder = CLGeocoder();
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBAction func editModeToggle(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true);
        
        DispatchQueue.main.async(execute: {() in
            self.tableView.reloadData();
        });
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            NSLog("found location \(loc)");
            let lat: Double = loc.coordinate.latitude;
            let lon: Double = loc.coordinate.longitude;
            
            NSLog("\(lat), \(lon)");
            
            DataHandler.fetchCoordinates(latitude: lat, longitude: lon, doneHandler: {(title: String?) -> Void in
                DispatchQueue.main.async(execute: {() in
                    if let s = title {
                        self.currentSelection = s;
                        DataHandler.state.currentCity = self.currentSelection;
                        self.navItem.title = self.currentSelection;
                    }
                    self.activityIndicator.stopAnimating();
                });
            });
            
            geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
                self.activityIndicator.stopAnimating();
                if let error = error {
                    print("Error geocoding: \(error)");
                } else {
                    if let place = placemarks?.first {
                        NSLog("in \(place.locality!)");
                    } else {
                        print("location not found");
                    }
                }
            })
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cells = 1;
        cells += locales.count;
        
        if (self.tableView.isEditing) {
            cells += 1;
        }
        
        return cells;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        let row: Int = indexPath.row - 1;
        if (row == -1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "CityCell")!;
            cell.textLabel!.text = "Use GPS";
            cell.addSubview(activityIndicator);
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                activityIndicator.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -8)
                ]);
            
        } else if (row < locales.count) {
            cell = tableView.dequeueReusableCell(withIdentifier: "CityCell")!;
            cell.textLabel!.text = locales[row];
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddCityCell")!;
            if let addCell = cell as? CityAddTableViewCell {
                if let button = addCell.addButton as? PassableUIButton {
                    button.field = addCell.cityName;
                    button.addTarget(self, action: #selector(self.addCityName(_:)), for: .touchUpInside)
                }
            }
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var row = indexPath.row;
        if (row == 0) {
            self.locationManager.requestAlwaysAuthorization();
            locationManager.startUpdatingLocation();
            activityIndicator.startAnimating();
        } else {
            row -= 1;
            currentSelection = self.locales[row];
            DataHandler.state.currentCity = currentSelection;
            navItem.title = currentSelection;
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 && indexPath.row != self.locales.count + 1);
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let index = indexPath.row - 1;
            
            self.locales.remove(at: index);
            
            DispatchQueue.main.async(execute: {() in
                self.tableView.reloadData();
            });
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locales = DataHandler.state.locales;
        currentSelection = DataHandler.state.currentCity;
        navItem.title = currentSelection;
        self.locationManager.delegate = self;
        
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func addCityName(_ sender: PassableUIButton) {
        if let name = sender.field.text {
            currentSelection = name;
            locales.append(name);
            DataHandler.state.currentCity = name;
            DataHandler.state.locales = locales;
            sender.field.text = "";
            DispatchQueue.main.async(execute: {() in
                self.tableView.reloadData();
            });
        }
    }
}
