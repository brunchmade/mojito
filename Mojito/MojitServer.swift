//
//  MojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit
import CocoaLumberjack

class MojitServer : IMKServer, MojitServerProtocol {
    // MARK: Properties
    // XXX: I don't think the candidates view stuff should be here, just to try out
    private let storyboard:NSStoryboard!
    private let windowController:NSWindowController!
    private let candidatesViewController:CandidatesViewController
    
    var selectedCandidate:EmojiCandidate? {
        get {
            let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
            if (index == NSNotFound) {
                return nil
            }
            return candidatesViewController.candidates[index]
        }
    }
    
    // MARK: Init
    override init!(name: String!, bundleIdentifier: String!) {
        storyboard = NSStoryboard(name: "Candidates", bundle: nil)
        windowController = storyboard.instantiateControllerWithIdentifier("CandidatesWindowController") as! NSWindowController
        candidatesViewController = windowController.contentViewController! as! CandidatesViewController
        super.init(name: name, bundleIdentifier: bundleIdentifier)
        // XXX
        // windowController.showWindow(self)
    }
    
    // MARK: MojitServerProtocol
    /// Build an EmojiInputEngine and return
    /// - Returns: An emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol! {
        // TODO: pass configuration and emoji lib data to emoji input engine
        return EmojiInputEngine()
    }
    
    func updateCandidates(candidates: [EmojiCandidate!]!) {
        DDLogInfo("Update candidates \(candidates)")
        candidatesViewController.candidates = candidates
    }
    
    func displayCandidates() {
        DDLogInfo("Display candidates")
        windowController.showWindow(self)
    }
    
    func hideCandidates() {
        DDLogInfo("Hide candidates")
        windowController.window!.orderOut(self)
    }

    
    func selectNext() {
        let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
        if (index == NSNotFound) {
            return
        }
        candidatesViewController.collectionView.selectionIndexes = NSIndexSet(index: (index + 1) % candidatesViewController.candidates.count)
    }
    
    func selectPrevious() {
        let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
        if (index == NSNotFound) {
            return
        }
        let count = candidatesViewController.candidates.count
        candidatesViewController.collectionView.selectionIndexes = NSIndexSet(index: (count + index - 1) % count)
        
    }
}
