//
//  MojitServerProtocol.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa
import ReactiveCocoa

protocol MojitServerProtocol {
    /// The selected candidate
    var selectedCandidate:MutableProperty<EmojiCandidate?> { get }
    
    /// Property for determining whether the candidates view is visible or not
    var candidatesVisible:MutableProperty<Bool> { get }
    
    /// Candidates to display
    var candidates:MutableProperty<[EmojiCandidate]> { get }
    
    /// The active input controller
    weak var activeInputController:MojitoInputController? { get set }
    
    /// Make an emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol
    
    /// Update candidates position according to given text rect
    func moveCandidates(rect: NSRect)
    
    /// Select next candidate
    func selectNext()
    
    /// Select previous candidate
    func selectPrevious()
}