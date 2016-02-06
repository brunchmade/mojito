//
//  AppDelegate.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/4/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

class AppDelegate: NSObject, NSApplicationDelegate {
    let log = XCGLogger.defaultInstance()
    var mojitServer:MojitServer!
    
    private var storyboard:NSStoryboard!
    private var windowController:CandidatesWindowController!
    private var candidatesViewController:CandidatesViewController!
    
    private var candidatesWindowViewModel:CandidatesWindowViewModel!
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        let connectionName = NSBundle.mainBundle().objectForInfoDictionaryKey("InputMethodConnectionName") as! String
        log.info("Connection \(connectionName)")
        
        self.mojitServer = MojitServer(name: connectionName, bundleIdentifier: NSBundle.mainBundle().bundleIdentifier!)
        log.info("Initialized IMKServer \(mojitServer)")
        
        self.storyboard = NSStoryboard(name: "Candidates", bundle: nil)
        self.windowController = storyboard.instantiateControllerWithIdentifier("CandidatesWindowController") as! CandidatesWindowController
        self.candidatesViewController = windowController.contentViewController! as! CandidatesViewController
        
        self.candidatesWindowViewModel = CandidatesWindowViewModel(mojitServer: mojitServer)
        
        windowController.bindViewModel(candidatesWindowViewModel)
    }
}
