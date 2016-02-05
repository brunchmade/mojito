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
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        let connectionName = NSBundle.mainBundle().objectForInfoDictionaryKey("InputMethodConnectionName") as! String
        log.info("Connection \(connectionName)")
        self.mojitServer = MojitServer(name: connectionName, bundleIdentifier: NSBundle.mainBundle().bundleIdentifier!)
        log.info("Initialized IMKServer \(mojitServer)")
    }
}
