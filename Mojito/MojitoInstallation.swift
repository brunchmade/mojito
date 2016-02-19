//
//  File.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger

enum MojitoInstallationError:ErrorType {
    case InstallInputMethodError
    case UninstallInputMethodError
}

class MojitoInstallation {
    static let log = XCGLogger.defaultInstance()
    /// Whether the mojito input method installed
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
    
    class func targetInputMethodURL() -> NSURL {
        let bundleURL = NSBundle.mainBundle().bundleURL
        let inputMethodDirs = NSSearchPathForDirectoriesInDomains(.InputMethodsDirectory, [.UserDomainMask], true)
        let inputMethodDir = inputMethodDirs.first!
        let appFolderName = bundleURL.lastPathComponent!
        let targetInputMethodURL = NSURL(fileURLWithPath: (inputMethodDir as NSString).stringByAppendingPathComponent(appFolderName), isDirectory: true)
        return targetInputMethodURL
    }
    
    /// Install mojito
    class func install() throws {
        let bundleID = NSBundle.mainBundle().bundleIdentifier!
        let bundleURL = NSBundle.mainBundle().bundleURL
        var inputSource = OVInputSourceHelper.inputSourceForInputSourceID(bundleID)
        let targetInputMethodURL = self.targetInputMethodURL()
        if (inputSource == nil) {
            log.info("Create symbolic link at \(targetInputMethodURL) to \(bundleURL) for \(bundleID)")
            
            // Notice: As we are copying the whole app bundle to "~/Library/Input Methods"
            // the app installed in "/Application" could be different version from the one
            // installed, maybe we should find a way to solve the problem.
            // The way I tried to solve this problem was to do a symbolic link, but the problem
            // is to detect whether we are running under config mode or not, we see the bundle path,
            // however as if the bundle is a symbolic link to folder other than "~/Library/Input Methods",
            // we will have problem for detecting mode.
            
            // the target app folder already exists, replace it
            if (NSFileManager.defaultManager().fileExistsAtPath(targetInputMethodURL.path!)) {
                try NSFileManager.defaultManager().removeItemAtURL(targetInputMethodURL)
                try NSFileManager.defaultManager().copyItemAtURL(bundleURL, toURL: targetInputMethodURL)
            // the target app folder doesn't exist, copy to it
            } else {
                try NSFileManager.defaultManager().copyItemAtURL(bundleURL, toURL: targetInputMethodURL)
            }
            
            log.info("Register input source \(bundleID) at \(bundleURL.absoluteString)")
            if (!OVInputSourceHelper.registerInputSource(bundleURL)) {
                log.error("Failed to register input source \(bundleURL.absoluteString)")
                throw MojitoInstallationError.InstallInputMethodError
            }
            
            inputSource = OVInputSourceHelper.inputSourceForInputSourceID(bundleID)
            if (inputSource == nil) {
                log.error("Cannot find input source \(bundleID) after install")
                throw MojitoInstallationError.InstallInputMethodError
            }
        }

        if(!OVInputSourceHelper.enableInputSource(inputSource.takeUnretainedValue())) {
            log.error("Cannot enable input source")
            throw MojitoInstallationError.InstallInputMethodError
        }
        
        if (!OVInputSourceHelper.inputSourceEnabled(inputSource.takeUnretainedValue())) {
            log.error("Input source \(bundleID) is not enabled")
            throw MojitoInstallationError.InstallInputMethodError
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
                throw MojitoInstallationError.InstallInputMethodError
            }
        }
        let targetInputMethodURL = self.targetInputMethodURL()
        if (NSFileManager.defaultManager().fileExistsAtPath(targetInputMethodURL.path!)) {
            try NSFileManager.defaultManager().removeItemAtURL(targetInputMethodURL)
        }
        log.info("Input source \(bundleID) uninstalled")
    }
    
}
