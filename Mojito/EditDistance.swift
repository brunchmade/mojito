//
//  EditDistance.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/29/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation

/// Class for calculating edit distance for two given string
/// - Reference: https://en.wikipedia.org/wiki/Levenshtein_distance
class EditDistance {
    
    class func distance(lhs: String!, rhs: String!) -> Int {
        // degenerate cases
        if (lhs == rhs) {
            return 0
        }
        if (lhs.characters.count == 0) {
            return rhs.characters.count
        }
        if (rhs.characters.count == 0) {
            return lhs.characters.count
        }
        // FIXME
        return 0
    }
}