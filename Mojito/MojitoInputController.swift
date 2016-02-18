//
//  MojitoInputController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation
import XCGLogger
import InputMethodKit

// Inherit NSObject so that this class can be used with Objective C
class MojitoInputController : NSObject {
    let log = XCGLogger.defaultInstance()
    // String buffer for input chars
    private var inputBuffer:String = "" {
        didSet {
            if (inputBuffer.characters.count >= 3) {
                mojitoServer.candidatesVisible.value = true
            } else {
                mojitoServer.candidatesVisible.value = false
            }
            engine.keyword = inputKeyword
            let candidates = engine.candidates()
            if (candidates.count > 0) {
                mojitoServer.candidates.value = candidates
                var rect = NSRect()
                textInput.attributesForCharacterIndex(0, lineHeightRectangle: &rect)
                mojitoServer.moveCandidates(rect)
            }
            textInput.setMarkedText(inputBuffer, selectionRange: NSMakeRange(0, inputBuffer.characters.count), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
        }
    }
    
    /// The keyword part in input buffer
    /// For example, if the input buffer is something like `:foo bar:`, then the keyword should be `foo bar`
    private var inputKeyword:String {
        get {
            // we have no colon prefix, or the colon is the only char, just return ""
            if (!inputBuffer.hasPrefix(":") || inputBuffer.characters.count == 1) {
                return ""
            }
            let startIndex = inputBuffer.startIndex.advancedBy(1)
            var endIndex:String.Index!
            // we have colon suffix, return the stuff between two
            if (inputBuffer.hasSuffix(":")) {
                endIndex = inputBuffer.endIndex.advancedBy(-1)
            } else {
                endIndex = inputBuffer.endIndex
            }
            // when it comes to here, it means we have no colon suffix, just return things after the first colon
            return inputBuffer.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
        }
    }
    private var inputEmojiMode:Bool = false {
        didSet {
            if (!inputEmojiMode) {
                mojitoServer.candidatesVisible.value = false
            }
        }
    }
    private var mojitoServer:MojitoServerProtocol
    private var engine:EmojiInputEngineProtocol
    private var textInput:IMKTextInput
    
    init!(server: IMKServer, delegate: AnyObject!, client inputClient: AnyObject) {
        log.info("Init MojitoInputController, server=\(server), delegate=\(delegate), client=\(inputClient)")
        mojitoServer = server as! MojitoServerProtocol
        engine = mojitoServer.makeEmojiInputEngine()
        textInput = inputClient as! IMKTextInput
        super.init()
        mojitoServer.activeInputController = self
    }
    
    func menu() -> NSMenu! {
        return nil
    }
    
    func activateServer(sender: AnyObject) {
        textInput = sender as! IMKTextInput
        log.info("activateServer \(sender)")
        // TODO: maybe we should find a better way to let UI notify input controller that a candidate is double clicked?
        mojitoServer.activeInputController = self
        reset()
    }
    
    func deactivateServer(sender: AnyObject) {
        textInput = sender as! IMKTextInput
        log.info("deactivateServer \(sender)")
        mojitoServer.candidatesVisible.value = false
        mojitoServer.activeInputController = nil
        reset()
    }
    
    override func didCommandBySelector(aSelector: Selector, client sender: AnyObject) -> Bool {
        textInput = sender as! IMKTextInput
        log.info("didCommandBySelector \(aSelector) \(sender)")
        if (aSelector == "insertNewline:") {
            log.info("Insert new line")
            if (inputEmojiMode) {
                self.commitComposition(sender)
                return true
            }
        } else if (aSelector == "deleteBackward:") {
            if (inputEmojiMode) {
                if (inputBuffer.characters.count > 1) {
                    inputBuffer = inputBuffer.substringWithRange(Range<String.Index>(start: inputBuffer.startIndex, end: inputBuffer.endIndex.advancedBy(-1)))
                    return true
                // We run out of input buffer, leave input emoji mode and clear the buffer
                } else {
                    inputBuffer = ""
                    inputEmojiMode = false
                    return true
                }
            }
        // navigate to the next emoji candidate
        // TODO: should also support shift + tab, not sure how can we get shift here thought
        } else if (aSelector == "moveLeft:" || aSelector == "moveUp:" ) {
            if (inputEmojiMode) {
                mojitoServer.selectPrevious()
                return true
            }
        // navigate to the previous emoji candidate
        } else if (aSelector == "moveRight:" || aSelector == "moveDown:" || aSelector == "insertTab:") {
            if (inputEmojiMode) {
                mojitoServer.selectNext()
                return true
            }
        // ESC pressed, exit emoji input mode
        } else if (aSelector == "cancelOperation:") {
            if (inputEmojiMode) {
                // flush the input buffer if it's not empty
                if (inputBuffer.characters.count > 0) {
                    textInput.insertText(inputBuffer, replacementRange: NSMakeRange(NSNotFound, NSNotFound))
                }
                reset()
                return true
            }
        // we only want to swllow commands when we are in emoji mode
        } else {
            return inputEmojiMode
        }
        return false
    }
    
    override func commitComposition(sender: AnyObject) {
        textInput = sender as! IMKTextInput
        log.info("commitComposition \(sender), inputBuffer=\(inputBuffer), selectedCandidate=\(mojitoServer.selectedCandidate.value)")
        if (inputEmojiMode) {
            if let emoji = mojitoServer.selectedCandidate.value {
                textInput.insertText(String(emoji.char), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
            // we don't have selected candidate, just flush the input buffer
            } else {
                textInput.insertText(inputBuffer, replacementRange: NSMakeRange(NSNotFound, NSNotFound))
            }
        }
        reset()
    }
    
    override func inputText(string: String, client sender: AnyObject) -> Bool {
        textInput = sender as! IMKTextInput
        if (string == ":" || inputEmojiMode) {
            // Just submit ":" when user type "::"
            if (string == ":" && inputBuffer.characters.count == 1) {
                textInput.insertText(":", replacementRange: NSMakeRange(NSNotFound, NSNotFound))
                inputEmojiMode = false
                inputBuffer = ""
                return true
            }
            
            inputEmojiMode = true
            inputBuffer.appendContentsOf(string)
            return true
        }
        return false
    }
    
    /// Submit candidate to text input
    func submitCandidate(emoji: EmojiCandidate) {
        textInput.insertText(String(emoji.char), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
        reset()
    }
    
    /// Reset state of input controller
    private func reset() {
        inputEmojiMode = false
        inputBuffer = ""
    }
    
}
