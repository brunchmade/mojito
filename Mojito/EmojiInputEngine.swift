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
    private let emojis:[Emoji!]!
    
    var keyword:String {
        get {
            return _keyword
        }
        
        set {
            _keyword = newValue
        }
    }
    
    init(emojis: [Emoji!]!) {
        self.emojis = emojis
    }
    
    func candidates() -> [EmojiCandidate!]! {
        // XXX: we should implement fuzzy search here instead
        for emoji in emojis {
            if (emoji.key == keyword) {
                return [EmojiCandidate(emoji: emoji)]
            }
        }
        return []
    }
}
