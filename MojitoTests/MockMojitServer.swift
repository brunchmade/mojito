//
//  MockMojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit
import ReactiveCocoa

class MockMojitServer: IMKServer, MojitServerProtocol {
    var emojiEngine:EmojiInputEngineProtocol
    var selectedCandidateToReturn:EmojiCandidate?
    var updateCandidatesCalls:NSMutableArray
    private(set) var candidatesVisible = MutableProperty<Bool>(false)
    private(set) var candidates = MutableProperty<[EmojiCandidate]>([])

    weak var activeInputController:MojitoInputController?
    var selectedCandidate:EmojiCandidate? {
        get {
            return selectedCandidateToReturn
        }
    }
    
    init!(engine: EmojiInputEngineProtocol = MockEmojiInputEngine()) {
        self.emojiEngine = engine
        updateCandidatesCalls = NSMutableArray()
        super.init()
    }
    
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol {
        return emojiEngine
    }

    func updateCandidates(candidates: [EmojiCandidate]) {
        updateCandidatesCalls.addObject(candidates)
    }
    
    func selectNext() {
    }
    
    func selectPrevious() {
        
    }
    
    func moveCandidates(rect: NSRect) {
        
    }
    
}