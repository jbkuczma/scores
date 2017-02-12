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
    @IBOutlet weak var nbaGameView: GameView!
    @IBOutlet weak var nhlGameView: GameView!
    
    @IBOutlet weak var yesterdayOrTodayButton: NSButton!
    
    var nbaGameMenuItem: NSMenuItem!
    var nhlGameMenuItem: NSMenuItem!
    var index = 0
    var lengthOfGameList = 0
    var isYesterday = false
    var yesterdayNBADate = ""
    var yesterdayNHLDate = ""
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let NBAapi = NBA_API()
    let NHLapi = NHL_API()
    
    @IBAction func yesterdayOrToday(_ sender: NSButton) {
        self.index = 0
        if(!isYesterday){
            let calendar = Calendar.current

            // gets current date time and converts via calendar to a valid date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            let newDate = formatter.date(from: dateString)
            
            let yesterday = calendar.date(byAdding: .day, value: -1, to: newDate!)
            var y = yesterday!.description.components(separatedBy: " ")[0]
            y = y.replacingOccurrences(of: "-", with: "")
            yesterdayNBADate = y
            NBAapi.getScores(date: y) { nba in
                self.isYesterday = true
                self.yesterdayOrTodayButton.title = "Today"
                self.nbaGameView.update(game: nba.games[self.index])
                self.lengthOfGameList = nba.numberOfGames
            }
        } else {
            yesterdayNBADate = NBAapi.getTodaysDate()
            NBAapi.getScores(date: yesterdayNBADate) { nba in
                self.isYesterday = false
                self.yesterdayOrTodayButton.title = "Yesterday"
                self.nbaGameView.update(game: nba.games[self.index])
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
        let nbaDate = NBAapi.getTodaysDate()
        let nhlDate = NHLapi.getTodaysDate()
        NBAapi.getScores(date: nbaDate) { nba in
            if let nbaMenuItem = self.scoresMenu.item(withTitle: "NBAGames") {
                self.updateScores(index: self.index)
            }
        }
        NHLapi.getScores(date: nhlDate) { nhl in
            if let nhlMenuItem = self.scoresMenu.item(withTitle: "NHLGames") {
                self.updateScores(index: self.index)
            }
//            print(nhl)
        }
        
    }
    
    func updateScores(index: Int) {
        let nbaDate = isYesterday ? yesterdayNBADate : NBAapi.getTodaysDate()
        let nhlDate = isYesterday ? yesterdayNHLDate : NHLapi.getTodaysDate()
        NBAapi.getScores(date: nbaDate) { nba in
            self.nbaGameView.update(game: nba.games[index])
            self.lengthOfGameList = nba.numberOfGames
        }
        NHLapi.getScores(date: nhlDate) { nhl in
            self.nhlGameView.update(game: nhl.games[index])
            self.lengthOfGameList = nhl.numberOfGames
        }
    }
    
    override func awakeFromNib() {
//        statusItem.title = "scores"
        statusItem.menu = scoresMenu
        
        nbaGameMenuItem = scoresMenu.item(withTitle: "NBAGames")
        nbaGameMenuItem.view = nbaGameView
        
        nhlGameMenuItem = scoresMenu.item(withTitle: "NHLGames")
        nhlGameMenuItem.view = nhlGameView
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        
        updateScores(index: index)
    }
}
