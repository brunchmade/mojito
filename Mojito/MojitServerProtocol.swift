//
//  MojitServerProtocol.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

protocol MojitServerProtocol {
    /// Make an emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol!
    
    /// Display candidates
    func displayCandidates()
    
    /// Hide candidates
    func hideCandidates()
    
    /// Update candidates
    func updateCandidates(candidates: [EmojiCandidate!]!)
}