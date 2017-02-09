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
    
    func getScores(date: String, success: @escaping (NBA) -> Void) {
        let url = URL(string: String(format: baseURL, date))
        var nba = NBA(games: [])
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    let nba = self.parseJSON(data: data! as NSData)
//                    print(nba!.games)
                    success(nba!)
                    
//                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//                    var jsonData = parsedData["sports_content"] as! [String:Any]
//                    var games = jsonData["games"] as! [String:Any]
//                    let gameList = games["game"] as? [[String:Any]]
//                    print(type(of:gameList))
//                    for game in gameList! {
//                        print(game)
//                    }
//                    nba.games = gameList!
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
        
    }
    
    func parseJSON(data: NSData) -> NBA? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data as Data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var jsonData = json["sports_content"] as! [String:Any]
        var games = jsonData["games"] as! [String:Any]
        let gameList = games["game"] as? [[String:Any]]
        
        
        let nba = NBA(
            games: gameList!
        )
        
        return nba
    }

    
}
