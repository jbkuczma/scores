//
//  NBA_API.swift
//  scores
//
//  Created by James Kuczmarski on 2/8/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Foundation

struct NBA {
    var games: [Game]
    var numberOfGames: Int
}

struct Game {
    var homeTeamName: String
    var homeTeamScore: String
    var awayTeamName: String
    var awayTeamScore: String
    var quarter: String
    var time: String
}

class NBA_API {
    
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
        var nba = NBA(games: [], numberOfGames: 0)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    if let nba = self.parseJSON(data: data! as NSData) {
                        success(nba)
                    }
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
        
        var nba = NBA(games: [], numberOfGames: 0)
        for game in gameList! {
            let g = game as! NSDictionary
            let home = g["home"] as! NSDictionary
            let away = g["visitor"] as! NSDictionary
            let gameStatus = g["period_time"] as! NSDictionary
            
            let awayTeamName = away["abbreviation"]! as! String
            let awayTeamScore = away["score"]! as! String
            let homeTeamName = home["abbreviation"]! as! String
            let homeTeamScore = home["score"]! as! String
            let quarter = gameStatus["period_status"]! as! String
            let time = gameStatus["game_clock"]! as! String
            
            let gameInfo = Game(
                homeTeamName: homeTeamName,
                homeTeamScore: homeTeamScore,
                awayTeamName: awayTeamName,
                awayTeamScore: awayTeamScore,
                quarter: quarter,
                time: time
            )
            
            nba.games.append(gameInfo)
            nba.numberOfGames+=1
        }
        
        
        
        return nba
    }

    
}
