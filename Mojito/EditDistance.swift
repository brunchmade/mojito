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
    
    class func distance(lhs lhs: String!, rhs: String!) -> Int! {
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
        var v0 = [Int](count: rhs.characters.count + 1, repeatedValue: 0)
        var v1 = [Int](count: rhs.characters.count + 1, repeatedValue: 0)
        
        // initialize v0 (the previous row of distances)
        // this row is A[0][i]: edit distance for an empty s
        // the distance is just the number of characters to delete from t
        for i in 0 ..< v0.count {
            v0[i] = i
        }

        for i in 0 ..< lhs.characters.count {
            // calculate v1 (current row distances) from the previous row v0
            
            // first element of v1 is A[i+1][0]
            //   edit distance is delete (i+1) chars from s to match empty t
            v1[0] = i + 1
            
            // use formula to fill in the rest of the row
            
            for j in 0 ..< rhs.characters.count {
                var cost:Int
                if (lhs[lhs.startIndex.advancedBy(i)] == rhs[rhs.startIndex.advancedBy(j)]) {
                    cost = 0
                } else {
                    cost = 1
                }
                v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
            }
            
            // copy v1 (current row) to v0 (previous row) for next iteration
            for j in 0 ..< v0.count {
                v0[j] = v1[j]
            }
        }
        return v1[rhs.characters.count]
    }
    
    /// Generate typo variants for given string within spepcifc edit distance
    class func generateTypos(string string: String!, distance:UInt!, alphabet: String! = "abcdefghijklmnopqrstuvwxyz0123456789") -> Set<String>! {
        var typos: [String]! = []
        _generateTypos(string, distance: distance, alphabet: alphabet, typos: &typos)
        return Set<String>(typos)
    }

    private class func _generateTypos(string: String!, distance:UInt!, alphabet: String!, inout typos: [String]!) {
        if (distance == 0) {
            return
        }
        // Insertion
        for char in alphabet.characters {
            for i in 0 ... string.characters.count {
                var insertedString = string
                insertedString.insert(char, atIndex: insertedString.startIndex.advancedBy(i))
                typos.append(insertedString)
                _generateTypos(insertedString, distance: distance - 1, alphabet: alphabet, typos: &typos)
            }
        }
        
        // Deletion
        for i in 0 ..< string.characters.count {
            var deletedString = string
            deletedString.removeAtIndex(deletedString.startIndex.advancedBy(i))
            typos.append(deletedString)
            _generateTypos(deletedString, distance: distance - 1, alphabet: alphabet, typos: &typos)
        }
        
        // Substitution
        for char in alphabet.characters {
            for i in 0 ..< string.characters.count {
                var subString = string
                subString.replaceRange(Range<String.Index>(start: subString.startIndex.advancedBy(i), end: subString.startIndex.advancedBy(i + 1)), with: String(char))
                if (subString == string) {
                    continue
                }
                typos.append(subString)
                _generateTypos(subString, distance: distance - 1, alphabet: alphabet, typos: &typos)
            }
        }
        
    }
}