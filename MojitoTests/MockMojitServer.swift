//
//  MockMojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit

class MockMojitServer: IMKServer, MojitServerProtocol {
    var emojiEngine:EmojiInputEngineProtocol?
    var selectedCandidateToReturn:EmojiCandidate?
    var updateCandidatesCalls:NSMutableArray
    // whether is candidates UI visible or not
    var candidatesVisible:Bool = false

    weak var activeInputController:MojitoInputController?
    var selectedCandidate:EmojiCandidate? {
        get {
            return selectedCandidateToReturn
        }
    }
    
    init!(engine: EmojiInputEngineProtocol!) {
        emojiEngine = engine
        if (emojiEngine == nil) {
            emojiEngine = MockEmojiInputEngine()
        }
        updateCandidatesCalls = NSMutableArray()
        super.init()
    }
    
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol! {
        return emojiEngine
    }

    func updateCandidates(candidates: [EmojiCandidate!]!) {
        updateCandidatesCalls.addObject(candidates)
    }
    
    func displayCandidates() {
        candidatesVisible = true
    }
    
    func hideCandidates() {
        candidatesVisible = false
    }
    
    func selectNext() {
    }
    
    func selectPrevious() {
        
    }
    
    func moveCandidates(rect: NSRect!) {
        
    }
    
}