//
//  CandidateWindowController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa

class CandidatesWindowController: NSWindowController {
    func moveForInputText(rect: NSRect) {
        var frame = window!.frame
        frame.origin = NSPoint(
            x: rect.origin.x + rect.width / 2 - frame.width / 2,
            y: rect.origin.y + rect.height + 10
        )
        window!.setFrame(frame, display: true, animate: true)
    }
}
