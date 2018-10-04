//
//  ForecastTableViewController.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    var uri = "https://api.openweathermap.org/data/2.5/forecast?q=Tampere,fi&units=metric&APPID=";
    var request: ForeCastRequest?;
    var nodes: [WeatherDataNode] = [];
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nodes.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell");
        cell!.imageView!.image = UIImage(named: nodes[indexPath.row].weather!.first!.icon!)
        return cell!;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DataHandler.fetchUrl(uri: uri, handler: doneFetching)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        print(resstr!);
        
        do {
            let attempt = try JSONDecoder().decode(ForeCastRequest.self, from: data!);
            
            request = attempt;
        } catch {
            NSLog("ERROR");
        }
        
        if let req = self.request {
            self.nodes = req.list!;
            
            // Execute stuff in UI thread
            DispatchQueue.main.async(execute: {() in
                self.tableView.reloadData();
            })
        }
    }
}
