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
import XCGLogger

class CandidatesViewController : NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    let log = XCGLogger.defaultInstance()
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
                    let newIndex = (index + 1) % viewModel.candidates.value.count
                    self.collectionView.selectionIndexes = NSIndexSet(index: newIndex)
                case .SelectPrevious:
                    let index = self.collectionView.selectionIndexes.firstIndex
                    if (index == NSNotFound) {
                        return
                    }
                    let count = viewModel.candidates.value.count
                    let newIndex = (count + index - 1) % count
                    self.collectionView.selectionIndexes = NSIndexSet(index: newIndex)
                }
            }
        viewModel.selectedCandidate <~ self.collectionView.rac_valuesForKeyPath("selectionIndexes", observer: nil)
            .toSignalProducer()
            .flatMapError { error in
                // there should be no error, raise fatal error?
                return SignalProducer.empty
            }
            .lift { signal in
                return signal
                    .map { selectionIndexes -> EmojiCandidate? in
                        let index = (selectionIndexes as! NSIndexSet).firstIndex
                        if (index == NSNotFound) {
                            return nil
                        }
                        return viewModel.candidates.value[index]
                }
            }
        self.collectionView.rac_valuesForKeyPath("selectionIndexes", observer: nil)
            .toSignalProducer()
            .startWithNext { [unowned self] _ in
                self.collectionView.scrollToItemsAtIndexPaths(self.collectionView.selectionIndexPaths, scrollPosition: .Top)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColors = [NSColor.clearColor()]
        visualEffectView.maskImage = Utils.bubbleDialogMaskImage(view.frame.size, cornerRadius: 7.0, footSize: NSSize(width: 27, height: 13))
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
            log.debug("Candidate selected at \(index)")
            viewModel.selectedCandidate.value = viewModel.candidates.value[index.indexAtPosition(1)]
        }
    }

}