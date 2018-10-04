//
//  DataFetcher.swift
//  Weather App
//
//  Created by Mikko Rauman on 04/10/2018.
//  Copyright © 2018 Mikko Rauman. All rights reserved.
//

import Foundation

class DataHandler {
    static func fetchUrl(uri : String, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: (uri + "71dbe8fbc30364feff60bc7f82760c5a"))
        
        let task = session.dataTask(with: url!, completionHandler: handler);
        
        task.resume();
    }
}
