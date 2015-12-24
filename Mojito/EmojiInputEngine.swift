//
//  EmojiInputEngine.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/23/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation

/// EmojiInputEngine protocol implementation by returning candidates matching
class EmojiInputEngine : EmojiInputEngineProtocol {
    private var _keyword:String!
    
    var keyword:String {
        get {
            return _keyword
        }
        
        set {
            _keyword = newValue
        }
    }
    
    init() {
        // FIXME: load emojilib here
    }
    
    func candidates() -> [EmojiCandidate!]! {
        // FIXME:
        return []
    }
}
