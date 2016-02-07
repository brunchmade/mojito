//
//  CandidatesItem.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/26/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa
import Foundation

private var kvoContext = 0

class CandidatesItem : NSCollectionViewItem {
    /// Callback function to be called when the candidate is selected by double click
    var submitCallback:(() -> Void)?
    @IBOutlet weak var label: NSTextField!

    dynamic var itemTitle:String! {
        get {
            if let obj = representedObject as? EmojiCandidate {
                return "\(obj.char) :\(obj.key):"
            } else {
                return "none"
            }
        }
    }
    
    override var selected:Bool {
        didSet {
            // ensure we will have layer
            view.wantsLayer = true
            // XXX: Not sure why the label would be nil here, so we just access it via subviews
            let label = view.subviews[0] as! NSTextField
            if (selected) {
                view.layer!.backgroundColor = NSColor.alternateSelectedControlColor().CGColor
                label.textColor = NSColor.whiteColor()
            } else {
                view.layer!.backgroundColor = nil
                label.textColor = NSColor.blackColor()
            }
        }
    }
    
    override func viewWillAppear() {
        view.wantsLayer = true
        view.layer!.cornerRadius = view.frame.height / 2.0
        view.layer!.masksToBounds = true
    }
    
    override func mouseDown(theEvent: NSEvent) {
        if (theEvent.clickCount <= 1) {
            super.mouseDown(theEvent)
            return
        }
        if let callback = submitCallback {
            callback()
        }
    }
    
    // Make the computed property `itemTitle` also observable when representedObject changes
    // ref: http://stackoverflow.com/a/34478382/25077
    dynamic class func keyPathsForValuesAffectingItemTitle() -> Set<String> {
        return ["representedObject.char", "representedObject.key"]
    }
}
