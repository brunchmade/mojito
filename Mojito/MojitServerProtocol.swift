//
//  MojitServerProtocol.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

protocol MojitServerProtocol {
    /// The selected candidate
    var selectedCandidate:EmojiCandidate? { get }
    
    /// Make an emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol!
    
    /// Display candidates
    func displayCandidates()
    
    /// Hide candidates
    func hideCandidates()
    
    /// Update candidates
    func updateCandidates(candidates: [EmojiCandidate!]!)
    
    /// Select next candidate
    func selectNext()
    
    /// Select previous candidate
    func selectPrevious()
}