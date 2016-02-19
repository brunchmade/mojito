//
//  CandidatesWindowViewModel.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import ReactiveCocoa

class CandidatesWindowViewModel {
    /// Property for input text rect
    var textRect:AnyProperty<NSRect!>
    /// Property for candidate window visibility
    var visible:AnyProperty<Bool>
    
    private let mojitoServer:MojitoServerProtocol
    
    init(mojitoServer:MojitoServerProtocol) {
        self.mojitoServer = mojitoServer
        let signal = mojitoServer.eventSignal
            .filter {
                switch($0) {
                case .CandidatesViewMoved:
                    return true
                default:
                    return false
                }
            }
            .map { event -> NSRect! in
                switch(event) {
                case let .CandidatesViewMoved(textRect):
                    return textRect
                default:
                    break
                }
                return nil
        }
        self.textRect = AnyProperty<NSRect!>(initialValue: nil, signal: signal)
        self.visible = AnyProperty<Bool>(mojitoServer.candidatesVisible)
    }
}