//
//  CandidatesViewController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa
import Foundation

class CandidatesViewController : NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    /// Collection view
    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    
    /// Candidates to display
    var candidates:[EmojiCandidate!]! = [] {
        didSet {
            collectionView.reloadData()
            // select the first one if it is available
            if (candidates.count > 0) {
                collectionView.selectionIndexes = NSIndexSet(index: 0)
            }
        }
    }
    
    // TODO: move these stuff to other place
    func roundCornerImage(cornerRadius: CGFloat) -> NSImage! {
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
    
    func maskImage(cornerRadius: CGFloat, footSize: NSSize) -> NSImage {
        let roundImage = roundCornerImage(cornerRadius)
        //let roundCornerImage = roundCornerImage(cornerRadius)
        let maskedImage = NSImage(size: view.frame.size, flipped: false) { rect in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColors = [NSColor.clearColor()]
        visualEffectView.maskImage = maskImage(7.0, footSize: NSSize(width: 27, height: 13))
        // XXXXXXX
        candidates = [
            EmojiCandidate(char: "😀", key: "a"),
            EmojiCandidate(char: "😀", key: "fo"),
            EmojiCandidate(char: "😀", key: "smile"),
            EmojiCandidate(char: "🍹", key: "mojito"),
            EmojiCandidate(char: "💩", key: "shit"),
            EmojiCandidate(char: "💩", key: "shit yolo foobar"),
        ]
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let candidateItem = collectionView.makeItemWithIdentifier("CandidatesItem", forIndexPath: indexPath)
        let emojiCandidate = candidates[indexPath.item]
        candidateItem.representedObject = emojiCandidate
        return candidateItem
    }
    
	func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return candidates.count
	}
    
    func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        // TODO: maybe there is a better way to measure the item size?
        let emojiCandidate = candidates[indexPath.item]
        let systemFont = NSFont.systemFontOfSize(13)
        let attrs = [
            NSFontNameAttribute: systemFont.fontName,
            NSFontSizeAttribute: 13
        ]
        let attrStr = NSAttributedString(string: "\(emojiCandidate.char) :\(emojiCandidate.key):", attributes: attrs as? [String: AnyObject])
        var size = attrStr.size()
        size.height = 24
        size.width += 8
        return size
    }

}