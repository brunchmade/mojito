//
//  MockMojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import InputMethodKit

class MockMojitServer: IMKServer, MojitServerProtocol {
    var emojiEngine:EmojiInputEngineProtocol?
    
    init!(engine: EmojiInputEngineProtocol!) {
        super.init()
        emojiEngine = engine
        if (emojiEngine == nil) {
            emojiEngine = MockEmojiInputEngine()
        }
    }
    
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol! {
        return emojiEngine
    }
}