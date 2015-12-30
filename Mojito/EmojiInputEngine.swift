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
        // XXX: for debug only
        if (keyword == "shit") {
            return [
                EmojiCandidate(char: "😀", key: ":a:"),
                EmojiCandidate(char: "😀", key: ":fo:"),
                EmojiCandidate(char: "😀", key: ":smile:"),
                EmojiCandidate(char: "🍹", key: ":mojito:"),
                EmojiCandidate(char: "💩", key: ":shit:"),
                EmojiCandidate(char: "💩", key: ":shit yolo foobar:"),
            ]
        }
        // FIXME:
        return []
    }
}
