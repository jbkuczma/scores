//
//  NBA_API.swift
//  scores
//
//  Created by James Kuczmarski on 2/8/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Foundation

struct NBA {
    var games: Array<Any>
}

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
                    var jsonData = parsedData["sports_content"] as! [String:Any]
                    var games = jsonData["games"] as! [String:Any]
                    let gameList = games["game"] as? [[String:Any]]
                    print(type(of:gameList))
                    for game in gameList! {
                        print(game)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
//    func parseJSONData(data: NSData) -> NBA? {
//        typealias JSONDict = [String:AnyObject]
//        let json : JSONDict
//        
//        do {
//            json = try JSONSerialization.jsonObject(with: data as Data, options: []) as! JSONDict
//        } catch {
//            print("JSON parsing failed: \(error)")
//            return nil
//        }
//        
////        var mainDict = json["sports_content"]?["games"]?["game"]
////        
////        let nba = NBA(
////            games: mainDict as Array<Any>!
////        )
////        
////        return nba
//    }
}
