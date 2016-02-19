//
//  MockMojitoServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit
import ReactiveCocoa
import Result

class MockMojitoServer: IMKServer, MojitoServerProtocol {
    var emojiEngine:EmojiInputEngineProtocol
    private(set) var candidatesVisible = MutableProperty<Bool>(false)
    private(set) var candidates = MutableProperty<[EmojiCandidate]>([])
    private(set) var selectedCandidate = MutableProperty<EmojiCandidate?>(nil)
    private(set) var eventSignal:Signal<MojitoServerEvent, NoError>
    weak var activeInputController:MojitoInputController?
    
    private let eventObserver:Observer<MojitoServerEvent, NoError>
    
    init!(engine: EmojiInputEngineProtocol = MockEmojiInputEngine()) {
        self.emojiEngine = engine
        (self.eventSignal, self.eventObserver) = Signal<MojitoServerEvent, NoError>.pipe()
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