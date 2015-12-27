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
    dynamic var itemTitle:String!
    
    override var selected:Bool {
        didSet {
            if (selected) {
                view.layer!.backgroundColor = NSColor(red: 0, green: 0.455, blue: 0.851, alpha: 1.0).CGColor /*#0074d9*/
            } else {
                view.layer!.backgroundColor = nil
            }
        }
    }
    
    override func viewDidLoad() {
        addObserver(self, forKeyPath: "representedObject", options: .New, context: &kvoContext)
    }
    
    override func viewWillAppear() {
        view.wantsLayer = true
        view.layer!.cornerRadius = view.frame.height / 2.0
        view.layer!.masksToBounds = true
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (context == &kvoContext) {
            if (keyPath == "representedObject") {
                if let obj = change?[NSKeyValueChangeNewKey] as? EmojiCandidate {
                    itemTitle = "\(obj.char) \(obj.key)"
                } else {
                    itemTitle = "none"
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}
