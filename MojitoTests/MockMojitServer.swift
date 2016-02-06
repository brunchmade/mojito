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
    private(set) var candidatesVisible = MutableProperty<Bool>(false)
    private(set) var candidates = MutableProperty<[EmojiCandidate]>([])
    private(set) var selectedCandidate = MutableProperty<EmojiCandidate?>(nil)

    weak var activeInputController:MojitoInputController?
    
    init!(engine: EmojiInputEngineProtocol = MockEmojiInputEngine()) {
        self.emojiEngine = engine
        super.init()
    }
    
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol {
        return emojiEngine
    }
    
    func selectNext() {
    }
    
    func selectPrevious() {
        
    }
    
    func moveCandidates(rect: NSRect) {
        
    }
    
}