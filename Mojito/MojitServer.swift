//
//  MojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit

class MojitServer : IMKServer, MojitServerProtocol {
    
    /// Build an EmojiInputEngine and return
    /// - Returns: An emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol! {
        // TODO: pass configuration and emoji lib data to emoji input engine
        return EmojiInputEngine()
    }
}
