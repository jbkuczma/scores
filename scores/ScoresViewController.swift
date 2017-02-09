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
    var index = 0
    var lengthOfGameList = 0
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let NBAapi = NBA_API()
    
    @IBAction func goBack(_ sender: NSButton) {
        if(self.index > 0){
            self.index-=1
            updateScores(index: self.index)
        }
    }
    @IBAction func goForward(_ sender: NSButton) {
        if(self.index < self.lengthOfGameList-1){
           self.index+=1
            updateScores(index: self.index)
        }
    }
    @IBAction func Refresh(_ sender: NSMenuItem) {
        let date = NBAapi.getTodaysDate()
        NBAapi.getScores(date: date) { nba in
            if let nbaMenuItem = self.scoresMenu.item(withTitle: "NBAGames") {
//                lengthOfGameList = nba.numberOfGames
                for game in nba.games {
                    print(game)
                    print("=====")
                }
                
                nbaMenuItem.title = "hi"
            }
        }
    }
    
    func updateScores(index: Int) {
        let date = NBAapi.getTodaysDate()
        NBAapi.getScores(date: date) { nba in
//            for game in nba.games {
//                self.gameView.update(game: game)
//            }
            self.gameView.update(game: nba.games[index])
            self.lengthOfGameList = nba.numberOfGames
        }
    }
    
    override func awakeFromNib() {
        statusItem.title = "scores"
        statusItem.menu = scoresMenu
        
        gameMenuItem = scoresMenu.item(withTitle: "NBAGames")
        gameMenuItem.view = gameView
        
        updateScores(index: index)
    }
}
