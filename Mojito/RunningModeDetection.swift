//
//  RunningMode.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

@objc enum RunningMode: Int {
    case InputMethod
    case Configuration
}

class RunningModeDetection: NSObject {
    /// Determine which mode we are running
    class func runningMode() -> RunningMode {
        let log = XCGLogger.defaultInstance()
        let appPath = NSBundle.mainBundle().bundlePath
        // determine whether are we running as a input method or app
        let inputMethodDirs = NSSearchPathForDirectoriesInDomains(.InputMethodsDirectory, [.UserDomainMask, .LocalDomainMask], true)
        let parentDir = (appPath as NSString).stringByDeletingLastPathComponent
        log.info("App path \(appPath)")
        log.info("Input method dirs \(inputMethodDirs)")
        log.info("Parent dir \(parentDir)")
        if (inputMethodDirs.contains(parentDir)) {
            log.info("Detected input method mode")
            return RunningMode.InputMethod
        }
        log.info("Detected configuration method mode")
        return RunningMode.Configuration
    }
}
