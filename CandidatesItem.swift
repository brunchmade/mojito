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
    @IBOutlet weak var label: NSTextField!

    dynamic var itemTitle:String! {
        get {
            if let obj = representedObject as? EmojiCandidate {
                return "\(obj.char) \(obj.key)"
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
                view.layer!.backgroundColor = NSColor(red: 0, green: 0.455, blue: 0.851, alpha: 1.0).CGColor /*#0074d9*/
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
    
    // Make the computed property `itemTitle` also observable when representedObject changes
    // ref: http://stackoverflow.com/a/34478382/25077
    dynamic class func keyPathsForValuesAffectingItemTitle() -> Set<String> {
        return ["representedObject.char", "representedObject.key"]
    }
}
