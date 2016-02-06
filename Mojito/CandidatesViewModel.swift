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
    
    private let mojitServer:MojitServerProtocol
    
    init(mojitServer:MojitServerProtocol) {
        self.mojitServer = mojitServer
        self.candidates = AnyProperty(mojitServer.candidates)
        self.eventSignal = mojitServer.eventSignal
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
    }

}