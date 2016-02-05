//
//  Logging.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/4/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

class Logging: NSObject {
    class func setupLogging() {
        let log = XCGLogger.defaultInstance()
        // Create a destination for the system console log (via NSLog)
        let systemLogDestination = XCGNSLogDestination(owner: log, identifier: "advancedLogger.systemLogDestination")
        
        // Optionally set some configuration options
        systemLogDestination.outputLogLevel = .Debug
        systemLogDestination.showLogIdentifier = false
        systemLogDestination.showFunctionName = true
        systemLogDestination.showThreadName = true
        systemLogDestination.showLogLevel = true
        systemLogDestination.showFileName = true
        systemLogDestination.showLineNumber = true
        systemLogDestination.showDate = true
        
        // Add the destination to the logger
        log.addLogDestination(systemLogDestination)
    }
}