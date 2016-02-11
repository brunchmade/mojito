//
//  ConfigAppDelegate.swift
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
    private var viewModel:ConfigViewModel!
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        log.info("Running configuration app")
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        let status = TransformProcessType(&psn, UInt32(kProcessTransformToForegroundApplication))
        if (status != noErr) {
            log.error("Failed to transform process into a forgeground app")
        }
        
        self.storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.windowController = storyboard.instantiateControllerWithIdentifier("ConfigWindowController") as! NSWindowController
        self.viewController = windowController.contentViewController! as! ConfigViewController
        
        self.viewModel = ConfigViewModel()
        
        viewController.bindViewModel(viewModel)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
