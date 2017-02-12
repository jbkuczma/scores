//
//  NHL_API.swift
//  scores
//
//  Created by James Kuczmarski on 2/10/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Foundation

struct NHL {
    var games: [Game]
    var numberOfGames: Int
}


class NHL_API {
    
    // date format: yyyy-mm-dd
    
    let baseURL = "http://live.nhle.com/GameData/GCScoreboard/%@.jsonp"
    
    func getTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func getScores(date: String, success: @escaping (NHL) -> Void) {
        let url = URL(string: String(format: baseURL, date))
        var nhl = NHL(games: [], numberOfGames: 0)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    var newData = String(data: data!, encoding: .utf8)!
                    // remove 'loadScoreboard(' at beginning and ')' at end of string
                    let c = newData.characters
                    let range = c.index(c.startIndex, offsetBy: 15)..<c.index(c.endIndex, offsetBy: -2)
                    newData = newData[range]
                    
                    let jsonData = self.convertToDictionary(text: newData)! as! [String: Any]
                    let games = jsonData["games"] as? [[String:Any]]
 
                    if let nhl = self.parseData(data: games!) {
                        success(nhl)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func parseData(data: [[String:Any]]) -> NHL? {
        
       
        var nhl = NHL(games: [], numberOfGames: 0)
        for game in data {
            let awayTeamName = game["atcommon"]! as! String
            let awayTeamScore = game["ats"]! as! String
            let homeTeamName = game["htcommon"]! as! String
            let homeTeamScore = game["hts"]! as! String
            let quarter = game["bsc"]! as! String
            let time = game["bs"]! as! String
            let gameInfo = Game(
                homeTeamName: homeTeamName,
                homeTeamScore: homeTeamScore,
                awayTeamName: awayTeamName,
                awayTeamScore: awayTeamScore,
                quarter: quarter,
                time: time
            )
            nhl.games.append(gameInfo)
            nhl.numberOfGames+=1
        }
    
        return nhl
    }
    
    
}
