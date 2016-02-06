//
//  CandidatesViewController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa
import Foundation
import ReactiveCocoa

class CandidatesViewController : NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    var viewModel:CandidatesViewModel!
    
    /// Collection view
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    
    func bindViewModel(viewModel:CandidatesViewModel) {
        self.viewModel = viewModel
        viewModel.candidates.signal
            .observeNext { [unowned self] candidates in
                self.collectionView.reloadData()
                // select the first one if it is available
                if (candidates.count > 0) {
                    self.collectionView.selectionIndexes = NSIndexSet(index: 0)
                }
            }
        viewModel.eventSignal
            .observeNext { [unowned self] event in
                switch(event) {
                case .SelectNext:
                    let index = self.collectionView.selectionIndexes.firstIndex
                    if (index == NSNotFound) {
                        return
                    }
                    self.collectionView.selectionIndexes = NSIndexSet(index: (index + 1) % viewModel.candidates.value.count)
                case .SelectPrevious:
                    let index = self.collectionView.selectionIndexes.firstIndex
                    if (index == NSNotFound) {
                        return
                    }
                    let count = viewModel.candidates.value.count
                    self.collectionView.selectionIndexes = NSIndexSet(index: (count + index - 1) % count)
                }
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColors = [NSColor.clearColor()]
        visualEffectView.maskImage = UIUtils.bubbleDialogMaskImage(view.frame.size, cornerRadius: 7.0, footSize: NSSize(width: 27, height: 13))
    }
    
    /// Called to handle submit canddate event from the UI
    private func submitCandidate(item: CandidatesItem) {
        viewModel.submitCandidate(item.representedObject as! EmojiCandidate)
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let candidateItem = collectionView.makeItemWithIdentifier("CandidatesItem", forIndexPath: indexPath) as! CandidatesItem
        let emojiCandidate = viewModel.candidates.value[indexPath.item]
        candidateItem.representedObject = emojiCandidate
        candidateItem.submitCallback = {
            self.submitCandidate(candidateItem)
        }
        return candidateItem
    }
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.candidates.value.count
    }
    
    func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        // TODO: maybe there is a better way to measure the item size?
        let emojiCandidate = viewModel.candidates.value[indexPath.item]
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
    
    func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
        if let index = indexPaths.first {
            viewModel.selectedCandidate.value = viewModel.candidates.value[index.indexAtPosition(1)]
        }
    }

}