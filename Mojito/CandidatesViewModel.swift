//
//  CandidatesViewModel.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/5/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

enum CandidatesViewModelEvent {
    case SelectNext
    case SelectPrevious
}

class CandidatesViewModel {
    var candidates:AnyProperty<[EmojiCandidate]>
    let eventSignal:Signal<CandidatesViewModelEvent, NoError>
    private(set) var selectedCandidate = MutableProperty<EmojiCandidate?>(nil)
    
    private let mojitoServer:MojitoServerProtocol
    
    init(mojitoServer:MojitoServerProtocol) {
        self.mojitoServer = mojitoServer
        self.candidates = AnyProperty(mojitoServer.candidates)
        self.eventSignal = mojitoServer.eventSignal
            .filter {
                switch($0) {
                case .SelectNext:
                    return true
                case .SelectPrevious:
                    return true
                default:
                    return false
                }
            }
            .map { event -> CandidatesViewModelEvent in
                var resultEvent:CandidatesViewModelEvent!
                switch(event) {
                case .SelectNext:
                    resultEvent = CandidatesViewModelEvent.SelectNext
                case .SelectPrevious:
                    resultEvent = CandidatesViewModelEvent.SelectPrevious
                default:
                    break
                }
                return resultEvent
            }
        mojitoServer.selectedCandidate <~ selectedCandidate
    }

    func submitCandidate(emoji: EmojiCandidate) {
        if let controller = mojitoServer.activeInputController {
            controller.submitCandidate(emoji)
        }
    }
}