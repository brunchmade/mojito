//
//  CandidateWindow.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/30/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa
import Foundation

class CandidateWindow: NSWindow {
    private var initialLocation:NSPoint?
    
    override var canBecomeKeyWindow:Bool {
        get {
            return true
        }
    }
    
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: contentRect, styleMask: NSBorderlessWindowMask, backing: bufferingType, `defer`: flag)
        opaque = false
        backgroundColor = NSColor.clearColor()
        // ref: https://github.com/danielpunkass/Blockpass/blob/master/Blockpass/AppDelegate.swift#L53-L55
        // NSStatusWindowLevel doesn't seem available in Swift? And the types for CG constants
        // are mismatched Int vs Int32 so we have to do this dance
        level = Int(CGWindowLevelForKey(CGWindowLevelKey.StatusWindowLevelKey))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.initialLocation = theEvent.locationInWindow
    }

    /*
    Once the user starts dragging the mouse, move the window with it. The window has no title bar for
    the user to drag (so we have to implement dragging ourselves)
    */
    override func mouseDragged(theEvent: NSEvent) {
        let screenVisibleFrame = NSScreen.mainScreen()!.visibleFrame
        let windowFrame = frame
        var newOrigin = windowFrame.origin
        let currentLocation = theEvent.locationInWindow
        newOrigin.x += currentLocation.x - initialLocation!.x
        newOrigin.y += currentLocation.y - initialLocation!.y
        
        // Don't let window get dragged up under the menu bar
        if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
            newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height)
        }
        
        // Move the window to the new location
        setFrameOrigin(newOrigin)
    }
    
}
