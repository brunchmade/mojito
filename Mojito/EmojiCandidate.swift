//
//  EmojiCandidate.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/23/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

// Need to implement methodSignatureForSelector so that UI value binding could work with it

import Cocoa

class EmojiCandidate : NSObject {
    /// Character of the emoji candidate
    var char:Character!
    /// The key name for the emoji, e.g. for :grinning:, the key is `grinning`
    var key:String!

    init(char: Character!, key: String!) {
        self.char = char
        self.key = key
    }
}