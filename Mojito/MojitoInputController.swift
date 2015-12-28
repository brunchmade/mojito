//
//  MojitoInputController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation
import InputMethodKit
import CocoaLumberjack

// Inherit NSObject so that this class can be used with Objective C
class MojitoInputController : NSObject {
    // String buffer for input chars
    private var inputBuffer:String! = "" {
        didSet {
            engine.keyword = inputKeyword
            let candidates = engine.candidates()
            mojitServer.updateCandidates(candidates)
            textInput.setMarkedText(inputBuffer, selectionRange: NSMakeRange(0, inputBuffer.characters.count), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
        }
    }
    
    /// The keyword part in input buffer
    /// For example, if the input buffer is something like `:foo bar:`, then the keyword should be `foo bar`
    private var inputKeyword:String! {
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
            if (inputEmojiMode) {
                mojitServer.displayCandidates()
            } else {
                mojitServer.hideCandidates()
            }
        }
    }
    private var mojitServer:MojitServerProtocol!
    private var engine:EmojiInputEngineProtocol!
    private var textInput:IMKTextInput!
    
    init!(server: IMKServer!, delegate: AnyObject!, client inputClient: AnyObject!) {
        super.init()
        DDLogInfo("Init MojitoInputController, server=\(server), delegate=\(delegate), client=\(inputClient)")
        // TODO: test to see if server is a MojitServerProtocol otherwise raise error?
        mojitServer = server as! MojitServerProtocol
        engine = mojitServer.makeEmojiInputEngine()
        textInput = inputClient as! IMKTextInput
    }
    
    func menu() -> NSMenu! {
        return nil
    }
    
    func activateServer(sender: AnyObject!) {
        textInput = sender as! IMKTextInput
        DDLogInfo("activateServer \(sender)")
        reset()
    }
    
    func deactivateServer(sender: AnyObject!) {
        textInput = sender as! IMKTextInput
        DDLogInfo("deactivateServer \(sender)")
        mojitServer.hideCandidates()
    }
    
    override func didCommandBySelector(aSelector: Selector, client sender: AnyObject!) -> Bool {
        textInput = sender as! IMKTextInput
        DDLogInfo("didCommandBySelector \(aSelector) \(sender)")
        if (aSelector == "insertNewline:") {
            DDLogInfo("Insert new line")
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
        // navigate among emoji candidates
        } else if (aSelector == "moveLeft:") {
            mojitServer.selectPrevious()
            return true
        // navigate among emoji candidates
        } else if (aSelector == "moveRight:") {
            mojitServer.selectNext()
            return true
        // ESC pressed, exit emoji input mode
        } else if (aSelector == "cancelOperation:") {
            reset()
            return true
        } else {
            // FIXME:
            return true
        }
        return false
    }
    
    override func commitComposition(sender: AnyObject!) {
        textInput = sender as! IMKTextInput
        DDLogInfo("commitComposition \(sender)")
        if (inputEmojiMode) {
            if let emoji = mojitServer.selectedCandidate {
                textInput.insertText(String(emoji.char), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
            }
        }
        reset()
    }
    
    override func inputText(string: String!, client sender: AnyObject!) -> Bool {
        textInput = sender as! IMKTextInput
        // TODO: only log this when we are building with debug
        DDLogInfo("inputText string:\(string), client:\(sender)")
        if (string == ":" || inputEmojiMode) {
            inputEmojiMode = true
            inputBuffer.appendContentsOf(string)
            return true
        }
        return false
    }
    
    /// Reset state of input controller
    private func reset() {
        inputEmojiMode = false
        inputBuffer = ""
    }
    
}
