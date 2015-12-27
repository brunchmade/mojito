//
//  CandidateWindowController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa

class CandidatesWindowController: NSWindowController {
    override func windowDidLoad() {
        // ref: https://github.com/danielpunkass/Blockpass/blob/master/Blockpass/AppDelegate.swift#L53-L55
        // NSStatusWindowLevel doesn't seem available in Swift? And the types for CG constants
        // are mismatched Int vs Int32 so we have to do this dance
        window!.level = Int(CGWindowLevelForKey(CGWindowLevelKey.StatusWindowLevelKey));
        window!.opaque = false
    }
}
