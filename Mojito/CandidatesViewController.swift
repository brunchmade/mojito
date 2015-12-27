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
    @IBOutlet weak var collectionView: NSCollectionView!
    // XXXX
    var candidates:[EmojiCandidate!]! = [
        EmojiCandidate(char: "😀", key: ":simple:"),
        EmojiCandidate(char: "🍹", key: ":mojito:"),
        EmojiCandidate(char: "💩", key: ":shit:"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // TODO: measure the label size here
        return NSMakeSize(60, 20)
    }

}