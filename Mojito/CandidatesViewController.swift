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
    
    // XXXX
    var candidates:[EmojiCandidate!]! = [
        EmojiCandidate(char: "😀", key: ":a:"),
        EmojiCandidate(char: "😀", key: ":fo:"),
        EmojiCandidate(char: "😀", key: ":smile:"),
        EmojiCandidate(char: "🍹", key: ":mojito:"),
        EmojiCandidate(char: "💩", key: ":shit:"),
        EmojiCandidate(char: "💩", key: ":shit yolo foobar:"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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