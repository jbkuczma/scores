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
    
    func update(game: Game) {
        // do UI updates on the main thread
        DispatchQueue.main.async() {
            self.awayTeamName.stringValue = game.awayTeamName
            self.awayTeamScore.stringValue = game.awayTeamScore
            self.homeTeamName.stringValue = game.homeTeamName
            self.homeTeamScore.stringValue = game.homeTeamScore
            self.quarter.stringValue = game.quarter
            self.time.stringValue = game.time
        }
    }
    
}
