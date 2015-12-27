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
    // XXX: I don't think the candidates view stuff should be here, just to try out
    private let storyboard:NSStoryboard!
    private let windowController:NSWindowController!
    private let candidatesViewController:CandidatesViewController
    
    override init!(name: String!, bundleIdentifier: String!) {
        storyboard = NSStoryboard(name: "Candidates", bundle: nil)
        windowController = storyboard.instantiateControllerWithIdentifier("CandidatesWindowController") as! NSWindowController
        candidatesViewController = windowController.contentViewController! as! CandidatesViewController
        super.init(name: name, bundleIdentifier: bundleIdentifier)
        // XXX
        // windowController.showWindow(self)
    }
    
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

    var selectedCandidate:EmojiCandidate? {
        get {
            let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
            if (index == NSNotFound) {
                return nil
            }
            return candidatesViewController.candidates[index]
        }
    }
}
