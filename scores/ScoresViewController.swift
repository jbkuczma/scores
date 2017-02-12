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
    @IBOutlet weak var controlView: NSView!
    
    
    @IBOutlet weak var yesterdayOrTodayButton: NSButton!
    
    var nbaGameMenuItem: NSMenuItem!
    var nhlGameMenuItem: NSMenuItem!
    var nbaIndex = 0
    var nhlIndex = 0
    var lengthOfNBAGameList = 0
    var lengthOfNHLGameList = 0
    var isYesterday = false
    var yesterdayNBADate = ""
    var yesterdayNHLDate = ""
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let NBAapi = NBA_API()
    let NHLapi = NHL_API()
    
    @IBAction func yesterdayOrToday(_ sender: NSButton) {
        self.nbaIndex = 0
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
            yesterdayNHLDate = y
            y = y.replacingOccurrences(of: "-", with: "")
            yesterdayNBADate = y
            NBAapi.getScores(date: yesterdayNBADate) { nba in
                self.isYesterday = true
                self.yesterdayOrTodayButton.title = "Today"
                self.nbaGameView.update(game: nba.games[self.nbaIndex])
                self.lengthOfNBAGameList = nba.numberOfGames
            }
            NHLapi.getScores(date: yesterdayNHLDate) { nhl in
                self.nhlGameView.update(game: nhl.games[self.nhlIndex])
                self.lengthOfNHLGameList = nhl.numberOfGames
            }
        } else {
            yesterdayNBADate = NBAapi.getTodaysDate()
            yesterdayNHLDate = NHLapi.getTodaysDate()
            NBAapi.getScores(date: yesterdayNBADate) { nba in
                self.isYesterday = false
                self.yesterdayOrTodayButton.title = "Yesterday"
                self.nbaGameView.update(game: nba.games[self.nbaIndex])
                self.lengthOfNBAGameList = nba.numberOfGames
            }
            NHLapi.getScores(date: yesterdayNHLDate) { nhl in
                self.nhlGameView.update(game: nhl.games[self.nhlIndex])
                self.lengthOfNHLGameList = nhl.numberOfGames
            }
        }
    }
    
    @IBAction func goBack(_ sender: NSButton) {
        if(self.nbaIndex > 0){
            self.nbaIndex-=1
            updateNBAScores(index: self.nbaIndex)
        }
        if(self.nhlIndex > 0){
            self.nhlIndex-=1
            updateNHLScores(index: self.nhlIndex)
        }
    }
    
    @IBAction func goForward(_ sender: NSButton) {
        if(self.nbaIndex < self.lengthOfNBAGameList-1){
            self.nbaIndex+=1
            updateNBAScores(index: self.nbaIndex)
        }
        if(self.nhlIndex < self.lengthOfNHLGameList-1){
            self.nhlIndex+=1
            updateNHLScores(index: self.nhlIndex)
        }
    }
    
    @IBAction func Refresh(_ sender: NSMenuItem) {
        let nbaDate = NBAapi.getTodaysDate()
        let nhlDate = NHLapi.getTodaysDate()
        NBAapi.getScores(date: nbaDate) { nba in
            if let nbaMenuItem = self.scoresMenu.item(withTitle: "NBAGames") {
                self.updateNBAScores(index: self.nbaIndex)
            }
        }
        NHLapi.getScores(date: nhlDate) { nhl in
            if let nhlMenuItem = self.scoresMenu.item(withTitle: "NHLGames") {
                self.updateNHLScores(index: self.nhlIndex)
            }
        }
        
    }
    
    func updateNBAScores(index: Int) {
        let nbaDate = isYesterday ? yesterdayNBADate : NBAapi.getTodaysDate()
        NBAapi.getScores(date: nbaDate) { nba in
            self.nbaGameView.update(game: nba.games[index])
            self.lengthOfNBAGameList = nba.numberOfGames
        }
    }
    
    func updateNHLScores(index: Int) {
        let nhlDate = isYesterday ? yesterdayNHLDate : NHLapi.getTodaysDate()
        NHLapi.getScores(date: nhlDate) { nhl in
            self.nhlGameView.update(game: nhl.games[index])
            self.lengthOfNHLGameList = nhl.numberOfGames
        }
    }
    
    override func awakeFromNib() {
//        statusItem.title = "scores"
        statusItem.menu = scoresMenu
        
        nbaGameMenuItem = scoresMenu.item(withTitle: "NBAGames")
        nbaGameMenuItem.view = nbaGameView
        
        nhlGameMenuItem = scoresMenu.item(withTitle: "NHLGames")
        nhlGameMenuItem.view = nhlGameView
        
        scoresMenu.item(withTitle: "Control")?.view = controlView
        
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        
        updateNBAScores(index: nbaIndex)
        updateNHLScores(index: nhlIndex)
    }
}
