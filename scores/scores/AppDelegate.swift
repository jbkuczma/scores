//
//  AppDelegate.swift
//  scores
//
//  Created by James Kuczmarski on 2/8/17.
//  Copyright © 2017 scores. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var scoresMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    @IBAction func NBAbutton(_ sender: NSMenuItem) {
//        NSApplication.shared().terminate(self)
    }
    
    @IBAction func NHLbutton(_ sender: NSMenuItem) {
        
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.title = "scores"
        statusItem.menu = scoresMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

