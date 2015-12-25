//
//  MojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit

class MojitServer : IMKServer, MojitServerProtocol {
    // XXX: I don't think the candidates view stuff should be here, just to try out
    private var storyboard:NSStoryboard!
    private var windowController:NSWindowController!
    
    override init!(name: String!, bundleIdentifier: String!) {
        super.init(name: name, bundleIdentifier: bundleIdentifier)
        // XXX
        storyboard = NSStoryboard(name: "Candidates", bundle: nil)
        windowController = storyboard.instantiateControllerWithIdentifier("CandidatesWindowController") as! NSWindowController
        windowController.window!.setFrame(NSMakeRect(0, 0, 200, 200), display: true)
        windowController.showWindow(self)
    }
    
    /// Build an EmojiInputEngine and return
    /// - Returns: An emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol! {
        // TODO: pass configuration and emoji lib data to emoji input engine
        return EmojiInputEngine()
    }
}
