//
//  UIUtils.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import Cocoa

/// Utilities
class Utils {
    class func roundCornerImage(cornerRadius: CGFloat) -> NSImage! {
        let edgeLength = 2.0 * cornerRadius + 1.0
        let roundCornerImage = NSImage(size: NSSize(width: edgeLength, height: edgeLength), flipped: false) { rect in
            let bezierPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            NSColor.blackColor().set()
            bezierPath.fill()
            return true
        }
        roundCornerImage.capInsets = NSEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        roundCornerImage.resizingMode = .Stretch
        return roundCornerImage
    }
    
    /// Make a bubble dialog mask image and return
    class func bubbleDialogMaskImage(frameSize:NSSize, cornerRadius: CGFloat, footSize: NSSize) -> NSImage {
        let roundImage = roundCornerImage(cornerRadius)
        //let roundCornerImage = roundCornerImage(cornerRadius)
        let maskedImage = NSImage(size: frameSize, flipped: false) { rect in
            NSColor.blackColor().set()
            
            // draw triangle
            let bezierPath = NSBezierPath()
            // the very bottom point
            bezierPath.moveToPoint(NSPoint(x: rect.origin.x + rect.width / 2, y: 1))
            // the right point
            bezierPath.lineToPoint(NSPoint(x: rect.origin.x + rect.width / 2 + footSize.width / 2, y: footSize.height + 2))
            // the left point
            bezierPath.lineToPoint(NSPoint(x: rect.origin.x + rect.width / 2 - footSize.width / 2, y: footSize.height + 2))
            bezierPath.closePath()
            bezierPath.fill()
            
            roundImage.drawInRect(NSRect(x: 0, y: footSize.height, width: rect.width, height: rect.height - footSize.height), fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1.0)
            
            //roundCornerImage
            return true
        }
        return maskedImage
    }
}