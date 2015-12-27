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
    // The candidate  for measuring size
    private var sizingCandidatesItem:CandidatesItem!
    /// Collection view
    @IBOutlet weak var collectionView: NSCollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColors = [NSColor.clearColor()]
        candidates = [
            EmojiCandidate(char: "😀", key: ":a:"),
            EmojiCandidate(char: "😀", key: ":fo:"),
            EmojiCandidate(char: "😀", key: ":smile:"),
            EmojiCandidate(char: "🍹", key: ":mojito:"),
            EmojiCandidate(char: "💩", key: ":shit:"),
            EmojiCandidate(char: "💩", key: ":shit yolo foobar:"),
        ]
        
        sizingCandidatesItem = CandidatesItem(nibName: "CandidatesItem", bundle: nil)
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
        let emojiCandidate = candidates[indexPath.item]
        sizingCandidatesItem.representedObject = emojiCandidate
        // access item view here, so that it will be loaded
        let itemView = sizingCandidatesItem.view
        let label = sizingCandidatesItem.label
        label.stringValue = sizingCandidatesItem.itemTitle
        label.sizeToFit()
        itemView.layoutSubtreeIfNeeded()
        return itemView.bounds.size
    }

}