//
//  Helpers.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension SignalType {
    /// Returns a signal that will yield an array of values when `self` sends next
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    public func liveCollect() -> Signal<[Value], Error> {
        return self
            .scan([] as [Value]) { array, value in
                var appendedArray = array
                appendedArray.append(value)
                return appendedArray
        }
    }
}
