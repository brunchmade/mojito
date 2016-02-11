//
//  File.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

enum MojitInstallationError:ErrorType {
    case InstallInputMethodError
    case UninstallInputMethodError
}

class MojitInstallation {
    static let log = XCGLogger.defaultInstance()
    /// Whether the mojit input method installed
    class var installed:Bool {
        get {
            let bundleID = NSBundle.mainBundle().bundleIdentifier!
            let inputSource = OVInputSourceHelper.inputSourceForInputSourceID(bundleID)
            if let im = inputSource {
                return OVInputSourceHelper.inputSourceEnabled(im.takeUnretainedValue())
            }
            return false
        }
    }
    
    /// Install mojito
    class func install() throws {
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        let bundleURL = NSBundle.mainBundle().bundleURL
        var inputSource = OVInputSourceHelper.inputSourceForInputSourceID(bundleID)
        if (inputSource == nil) {
            let inputMethodDirs = NSSearchPathForDirectoriesInDomains(.InputMethodsDirectory, [.UserDomainMask], true)
            let inputMethodDir = inputMethodDirs.first!
            let appFolderName = bundleURL.lastPathComponent!
            let targetInputMethodURL = NSURL(fileURLWithPath: (inputMethodDir as NSString).stringByAppendingPathComponent(appFolderName), isDirectory: true)
            log.info("Create symbolic link at \(targetInputMethodURL) to \(bundleURL) for \(bundleID)")
            // the target app folder already exists, remove it first
            if (NSFileManager.defaultManager().fileExistsAtPath(targetInputMethodURL.path!)) {
                try NSFileManager.defaultManager().removeItemAtURL(targetInputMethodURL)
            }
            try NSFileManager.defaultManager().createSymbolicLinkAtURL(targetInputMethodURL, withDestinationURL:bundleURL)
            
            log.info("Register input source \(bundleID) at \(bundleURL.absoluteString)")
            if (!OVInputSourceHelper.registerInputSource(bundleURL)) {
                log.error("Failed to register input source \(bundleURL.absoluteString)")
                throw MojitInstallationError.InstallInputMethodError
            }
            
            inputSource = OVInputSourceHelper.inputSourceForInputSourceID(bundleID)
            if (inputSource == nil) {
                log.error("Cannot find input source \(bundleID) after install")
                throw MojitInstallationError.InstallInputMethodError
            }
        }

        if(!OVInputSourceHelper.enableInputSource(inputSource.takeUnretainedValue())) {
            log.error("Cannot enable input source")
            throw MojitInstallationError.InstallInputMethodError
        }
        
        if (!OVInputSourceHelper.inputSourceEnabled(inputSource.takeUnretainedValue())) {
            log.error("Input source \(bundleID) is not enabled")
            throw MojitInstallationError.InstallInputMethodError
        }
        log.info("Input source \(bundleID) installed")
    }
    
    /// Uninstall mojito
    class func uninstall() throws {
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        let bundleURL = NSBundle.mainBundle().bundleURL
        let inputSource = OVInputSourceHelper.inputSourceForInputSourceID(bundleID)
        if (inputSource != nil) {
            let status = OVInputSourceHelper.disableInputSource(inputSource.takeUnretainedValue())
            if (!status) {
                log.error("Failed to disable input source \(bundleURL.absoluteString)")
                throw MojitInstallationError.InstallInputMethodError
            }
        }
        log.info("Input source \(bundleID) uninstalled")
    }
    
}
