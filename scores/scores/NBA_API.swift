//
//  NBA_API.swift
//  scores
//
//  Created by James Kuczmarski on 2/8/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Foundation

class NBA_API {
//    let baseURL = String(format: "http://data.nba.com/data/5s/json/cms/noseason/scoreboard/%@/games.json", "2017")
    
//    let baseURL = "http://data.nba.com/data/5s/json/cms/noseason/scoreboard/{DATE}/games.json"
    
    let baseURL = "http://data.nba.com/data/5s/json/cms/noseason/scoreboard/%@/games.json"
    
    func getTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yMMdd"
        let result = formatter.string(from: date)
        return result
    }
    
    func getScores(date: String) {
        let url = URL(string: String(format: baseURL, date))
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    print(parsedData)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
}
