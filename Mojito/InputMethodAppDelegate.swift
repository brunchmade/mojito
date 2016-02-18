//
//  InputMethodAppDelegate.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/4/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

class InputMethodAppDelegate: NSObject, NSApplicationDelegate {
    let log = XCGLogger.defaultInstance()
    var mojitoServer:MojitoServer!
    
    private var storyboard:NSStoryboard!
    private var windowController:CandidatesWindowController!
    private var candidatesViewController:CandidatesViewController!
    
    private var candidatesWindowViewModel:CandidatesWindowViewModel!
    private var candidatesViewModel:CandidatesViewModel!
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        log.info("Running input method app")
        let connectionName = NSBundle.mainBundle().objectForInfoDictionaryKey("InputMethodConnectionName") as! String
        log.info("Connection \(connectionName)")
        
        self.mojitoServer = MojitoServer(name: connectionName, bundleIdentifier: NSBundle.mainBundle().bundleIdentifier!)
        log.info("Initialized IMKServer \(mojitoServer)")
        
        self.storyboard = NSStoryboard(name: "Candidates", bundle: nil)
        self.windowController = storyboard.instantiateControllerWithIdentifier("CandidatesWindowController") as! CandidatesWindowController
        self.candidatesViewController = windowController.contentViewController! as! CandidatesViewController
        
        self.candidatesWindowViewModel = CandidatesWindowViewModel(mojitoServer: mojitoServer)
        self.candidatesViewModel = CandidatesViewModel(mojitoServer: mojitoServer)
        
        windowController.bindViewModel(candidatesWindowViewModel)
        candidatesViewController.bindViewModel(candidatesViewModel)
    }
}
