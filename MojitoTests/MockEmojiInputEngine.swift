//
//  MockEmojiInputEngine.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

class MockEmojiInputEngine: EmojiInputEngineProtocol {
    var keyword:String = ""
    var candidatesToReturn:[EmojiCandidate] = []
    
    func candidates() -> [EmojiCandidate] {
        return candidatesToReturn
    }
}
