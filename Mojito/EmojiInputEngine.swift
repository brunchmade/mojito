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
    // map from keyword to emojis, e.g. "face": ["smile", "sad", ...]
    private let keywordIndex:[String:[Emoji!]!]!
    // Sorted keywords
    private let sortedKeywords:[String]!
    
    var keyword:String {
        get {
            return _keyword
        }
        
        set {
            _keyword = newValue
        }
    }
    
    init(emojis: [Emoji!]!) {
        var keywordIndex = [String:[Emoji!]!]()
        for emoji in emojis {
            var keywords = emoji.keywords
            keywords.append(emoji.key)
            for keyword in keywords {
                let normalizedKeyword = EmojiInputEngine.normalize(keyword)
                if keywordIndex[normalizedKeyword] != nil {
                    keywordIndex[normalizedKeyword]?.append(emoji)
                } else {
                    keywordIndex[normalizedKeyword] = [emoji]
                }
            }
        }
        self.keywordIndex = keywordIndex
        self.emojis = emojis
        self.sortedKeywords = Array(keywordIndex.keys).sort()
    }
    
    func candidates() -> [EmojiCandidate!]! {
        // TODO: Implement fuzzy search here
        let prefixMatches = EmojiInputEngine.binarySearch(EmojiInputEngine.normalize(keyword), array: sortedKeywords)
        var candidates:[EmojiCandidate!]! = []
        for match in prefixMatches {
            let emojis = keywordIndex[match]!
            candidates.appendContentsOf(emojis.map({
                return EmojiCandidate(emoji: $0)
            }))
        }
        return candidates
    }
    
    /// Do binary search for finding spefic prefix in string array
    class func binarySearch(prefix: String!, array: [String]!) -> [String]! {
        var left = 0
        var right = array.count - 1
        
        // find the smallest index
        while (right >= left) {
            let middleIndex = (left + right) / 2
            let middle = array[middleIndex]
            // find in the right partition
            if (prefix > middle) {
                left = middleIndex + 1
            // find in the left partition
            } else if (prefix < middle) {
                right = middleIndex - 1
            // looks like we find the prefix
            } else {
                left = middleIndex
                break
            }
        }
        
        var result:[String] = []
        for index in left ..< array.count {
            let keyword = array[index]
            if (!keyword.hasPrefix(prefix)) {
                break
            }
            result.append(keyword)
        }
        return result
    }
    
    /// Normalize keywords
    class func normalize(string: String!) -> String! {
        return string.lowercaseString
    }
}
