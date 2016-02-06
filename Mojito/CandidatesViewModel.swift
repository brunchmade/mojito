//
//  CandidatesViewModel.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/5/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import ReactiveCocoa

class CandidatesViewModel {
    var candidates:AnyProperty<[EmojiCandidate]>
    
    private let mojitServer:MojitServerProtocol
    
    init(mojitServer:MojitServerProtocol) {
        self.mojitServer = mojitServer
        self.candidates = AnyProperty(mojitServer.candidates)
    }

}