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
    // map from keyword to emoji keys, e.g. "face": ["smile", "sad", ...]
    private let keywordIndex:[String:[String]!]!
    
    var keyword:String {
        get {
            return _keyword
        }
        
        set {
            _keyword = newValue
        }
    }
    
    init(emojis: [Emoji!]!) {
        var keywordIndex = [String:[String]]()
        for emoji in emojis {
            var keywords = emoji.keywords
            keywords.append(emoji.key)
            for keyword in keywords {
                let normalizedKeyword = EmojiInputEngine.normalize(keyword)
                if keywordIndex[normalizedKeyword] != nil {
                    keywordIndex[normalizedKeyword]?.append(emoji.key)
                } else {
                    keywordIndex[normalizedKeyword] = [emoji.key]
                }
            }
        }
        self.keywordIndex = keywordIndex
        self.emojis = emojis
    }
    
    func candidates() -> [EmojiCandidate!]! {

        return []
    }
    
    /// Normalize given string by removing non alphabet and number character, also lower the case
    class func normalize(string: String!) -> String! {
        // FIXME:
        return string
    }
}
