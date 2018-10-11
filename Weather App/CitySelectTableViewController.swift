//
//  CitySelectTableViewController.swift
//  Weather App
//
//  Created by Mikko Rauman on 11/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import UIKit

class CityAddTableViewCell: UITableViewCell {
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

class CitySelectTableViewController: UITableViewController {
    var locales = [String]();
    var currentSelection = "";
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBAction func editModeToggle(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true);
        
        DispatchQueue.main.async(execute: {() in
            self.tableView.reloadData();
        });
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locales = DataHandler.state.locales;
        currentSelection = DataHandler.state.currentCity;
        navItem.title = currentSelection;
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
