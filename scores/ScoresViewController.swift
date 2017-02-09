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
    @IBOutlet weak var yesterdayOrTodayButton: NSButton!
    
    var gameMenuItem: NSMenuItem!
    var index = 0
    var lengthOfGameList = 0
    var isYesterday = false
    var yesterdayDate = ""
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let NBAapi = NBA_API()
    
    @IBAction func yesterdayOrToday(_ sender: NSButton) {
        self.index = 0
        if(!isYesterday){
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
            var y = yesterday!.description.components(separatedBy: " ")[0]
            y = y.replacingOccurrences(of: "-", with: "")
            yesterdayDate = y
            NBAapi.getScores(date: y) { nba in
                self.isYesterday = true
                self.yesterdayOrTodayButton.title = "Today"
                self.gameView.update(game: nba.games[self.index])
                self.lengthOfGameList = nba.numberOfGames
            }
        } else {
            yesterdayDate = NBAapi.getTodaysDate()
            NBAapi.getScores(date: yesterdayDate) { nba in
                self.isYesterday = false
                self.yesterdayOrTodayButton.title = "Yesterday"
                self.gameView.update(game: nba.games[self.index])
                self.lengthOfGameList = nba.numberOfGames
            }
        }
    }
    
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
//                for game in nba.games {
//                    print(game)
//                    print("=====")
//                }
//                
//                nbaMenuItem.title = "hi"
                self.updateScores(index: self.index)
            }
        }
    }
    
    func updateScores(index: Int) {
        let date = isYesterday ? yesterdayDate : NBAapi.getTodaysDate()
        NBAapi.getScores(date: date) { nba in
            self.gameView.update(game: nba.games[index])
            self.lengthOfGameList = nba.numberOfGames
        }
    }
    
    override func awakeFromNib() {
//        statusItem.title = "scores"
        statusItem.menu = scoresMenu
        
        gameMenuItem = scoresMenu.item(withTitle: "NBAGames")
        gameMenuItem.view = gameView
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        
        updateScores(index: index)
    }
}
