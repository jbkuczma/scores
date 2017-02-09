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
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let NBAapi = NBA_API()
    
    @IBAction func Refresh(_ sender: NSMenuItem) {
        let date = NBAapi.getTodaysDate()
        NBAapi.getScores(date: date) { nba in
            if let nbaMenuItem = self.scoresMenu.item(withTitle: "NBAGames") {
//                nbaMenuItem.title = String(describing: type(of:nba.games))
                var str = ""
                for game in nba.games {
//                    print(game)
                    str += String(describing: game)
                }
                nbaMenuItem.title = str
            }
        }
    }
    override func awakeFromNib() {
        statusItem.title = "scores"
        statusItem.menu = scoresMenu
    }
}
