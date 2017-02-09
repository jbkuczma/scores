//
//  ScoresMenuControler.swift
//  scores
//
//  Created by James Kuczmarski on 2/8/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Cocoa

class ScoresMenuController: NSObject {
    @IBOutlet weak var scoresMenu: NSMenu!
    @IBOutlet weak var gameView: GameView!
    
    var gameMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let NBAapi = NBA_API()
    
    @IBAction func Refresh(_ sender: NSMenuItem) {
        let date = NBAapi.getTodaysDate()
        NBAapi.getScores(date: date) { nba in
            if let nbaMenuItem = self.scoresMenu.item(withTitle: "NBAGames") {
                for game in nba.games {
                    print(game)
                    print("=====")
                }
                
                nbaMenuItem.title = "hi"
            }
        }
    }
    
    func updateScores() {
        let date = NBAapi.getTodaysDate()
        NBAapi.getScores(date: date) { nba in
//            for game in nba.games {
//                self.gameView.update(game: game)
//            }
            self.gameView.update(game: nba.games[0])
        }
//        self.scoresMenu.item(withTitle: "NBAGames")?.title = "hi"
    }
    
    override func awakeFromNib() {
        statusItem.title = "scores"
        statusItem.menu = scoresMenu
        
        gameMenuItem = scoresMenu.item(withTitle: "NBAGames")
        gameMenuItem.view = gameView
        
        updateScores()
    }
}
