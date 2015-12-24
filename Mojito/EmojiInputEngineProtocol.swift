//
//  EmojiInputEngineProtocol.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/23/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation

/// Emoji input engine protocol
protocol EmojiInputEngineProtocol {
    /// Keyword for emoji, e.g. :hankey: for 💩
    var keyword: String { get set }
    
    /// Get candidates for given emoji keyword
    /// - Returns: An Array of EmojiCandidate order by the matching score
    func candidates() -> [EmojiCandidate!]!
}