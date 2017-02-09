//
//  GameView.swift
//  scores
//
//  Created by James Kuczmarski on 2/9/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Cocoa

class GameView: NSView {
    
    
    @IBOutlet weak var awayTeamName: NSTextField!
    @IBOutlet weak var awayTeamScore: NSTextField!
    @IBOutlet weak var homeTeamName: NSTextField!
    @IBOutlet weak var homeTeamScore: NSTextField!
    @IBOutlet weak var quarter: NSTextField!
    @IBOutlet weak var time: NSTextField!
    
    func update(game: [String: Any]) {
        // do UI updates on the main thread
//        DispatchQueue.main.async() {
//            self.awayTeamName.stringValue = game["visitor"]["abbreviation"]
//            self.awayTeamScore.stringValue = game["visitor"]["score"]
//            self.homeTeamName.stringValue = game["home"]["abbreviation"]
//            self.homeTeamScore.stringValue = game["home"]["score"]
//            self.quarter.stringValue = game["period_time"]["period_status"]
//            self.time.stringValue = game["period_time"]["game_clock"]
//        }
    }
    
}
