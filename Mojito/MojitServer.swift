//
//  MojitServer.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import XCGLogger
import InputMethodKit
import SwiftyJSON
import ReactiveCocoa
import Result

class MojitServer : IMKServer, MojitServerProtocol {
    let log = XCGLogger.defaultInstance()

    /// Signal for mojit server events
    let eventSignal:Signal<MojitServerEvent, NoError>
    /// Is the candidates window visible or not
    private(set) var candidatesVisible = MutableProperty<Bool>(false)
    /// Candidates to display
    private(set) var candidates = MutableProperty<[EmojiCandidate]>([])
    /// Selected candidate
    private(set) var selectedCandidate = MutableProperty<EmojiCandidate?>(nil)
    
    // MARK: Properties
    private var emojis:[Emoji] = []
    private let eventObserver:Observer<MojitServerEvent, NoError>
    
    weak var activeInputController:MojitoInputController?
    
    // MARK: Init
    override init!(name: String, bundleIdentifier: String) {
        // read emoji lib data
        let bundle = NSBundle.mainBundle()
        let emojilibPath = bundle.pathForResource("emojilib", ofType: "json")
        let emojilibContent = NSData(contentsOfFile: emojilibPath!)
        let emojilibJSON = JSON(data: emojilibContent!)
        let keys = emojilibJSON["keys"]
        for (_, obj):(String, JSON) in keys {
            let key = obj.stringValue
            let subJSON = emojilibJSON[key]
            let categories:[String] = subJSON["category"].map({ $1.stringValue })
            let keywords:[String] = subJSON["keywords"].map({ $1.stringValue })
            if let char = subJSON["char"].string {
                let emoji = Emoji(
                    key: key,
                    char:char.characters.first!,
                    categories: categories,
                    keywords: keywords
                )
                emojis.append(emoji)
            }
        }
        
        (self.eventSignal, self.eventObserver) = Signal<MojitServerEvent, NoError>.pipe()
        super.init(name: name, bundleIdentifier: bundleIdentifier)
    }
    
    // MARK: MojitServerProtocol
    /// Build an EmojiInputEngine and return
    /// - Returns: An emoji input engine which conforms EmojiInputEngineProtocol
    func makeEmojiInputEngine() -> EmojiInputEngineProtocol {
        // TODO: pass configuration and emoji lib data to emoji input engine
        return EmojiInputEngine(emojis: emojis)
    }
    
    func moveCandidates(rect: NSRect) {
        self.eventObserver.sendNext(MojitServerEvent.CandidatesViewMoved(textRect: rect))
    }
    
    func selectNext() {
        self.eventObserver.sendNext(MojitServerEvent.SelectNext)
    }
    
    func selectPrevious() {
        self.eventObserver.sendNext(MojitServerEvent.SelectPrevious)
    }
}
