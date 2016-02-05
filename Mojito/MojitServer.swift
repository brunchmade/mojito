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

class MojitServer : IMKServer, MojitServerProtocol {
    let log = XCGLogger.defaultInstance()
    // MARK: Properties
    private let storyboard:NSStoryboard
    private let windowController:CandidatesWindowController
    private let candidatesViewController:CandidatesViewController
    private var emojis:[Emoji] = []
    
    weak var activeInputController:MojitoInputController?
    var selectedCandidate:EmojiCandidate? {
        get {
            let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
            if (index == NSNotFound) {
                return nil
            }
            return candidatesViewController.candidates[index]
        }
    }
    
    // MARK: Init
    override init!(name: String, bundleIdentifier: String) {
        self.storyboard = NSStoryboard(name: "Candidates", bundle: nil)
        self.windowController = storyboard.instantiateControllerWithIdentifier("CandidatesWindowController") as! CandidatesWindowController
        self.candidatesViewController = windowController.contentViewController! as! CandidatesViewController

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
        windowController.moveForInputText(rect)
    }
    
    func updateCandidates(candidates: [EmojiCandidate]) {
        log.info("Update candidates \(candidates)")
        candidatesViewController.candidates = candidates
    }
    
    func displayCandidates() {
        log.info("Display candidates")
        windowController.showWindow(self)
    }
    
    func hideCandidates() {
        log.info("Hide candidates")
        windowController.window!.orderOut(self)
    }
    
    func selectNext() {
        let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
        if (index == NSNotFound) {
            return
        }
        candidatesViewController.collectionView.selectionIndexes = NSIndexSet(index: (index + 1) % candidatesViewController.candidates.count)
    }
    
    func selectPrevious() {
        let index = candidatesViewController.collectionView.selectionIndexes.firstIndex
        if (index == NSNotFound) {
            return
        }
        let count = candidatesViewController.candidates.count
        candidatesViewController.collectionView.selectionIndexes = NSIndexSet(index: (count + index - 1) % count)
        
    }
}
