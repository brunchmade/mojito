//
//  ConfigurationAppDelegate.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

class ConfigAppDelegate: NSObject, NSApplicationDelegate {
    let log = XCGLogger.defaultInstance()
    
    private var storyboard:NSStoryboard!
    private var windowController:NSWindowController!
    private var viewController:ConfigViewController!
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        log.info("Running input method app")
        self.storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.windowController = storyboard.instantiateControllerWithIdentifier("ConfigWindowController") as! NSWindowController
        self.viewController = windowController.contentViewController! as! ConfigViewController
    }
}
