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
    private var inputBuffer:String! = ""
    private var inputEmojiMode:Bool = false
    private var mojitServer:MojitServerProtocol!
    private var engine:EmojiInputEngineProtocol!
    
    init!(server: IMKServer!, delegate: AnyObject!, client inputClient: AnyObject!) {
        super.init()
        DDLogInfo("Init MojitoInputController, server=\(server), delegate=\(delegate), client=\(inputClient)")
        // TODO: test to see if server is a MojitServerProtocol otherwise raise error?
        mojitServer = server as! MojitServerProtocol
        engine = mojitServer.makeEmojiInputEngine()
    }
    
    func menu() -> NSMenu! {
        return nil
    }
    
    func activateServer(sender: AnyObject!) {
        
        DDLogInfo("activateServer \(sender)")
    }
    
    func deactivateServer(sender: AnyObject!) {
        DDLogInfo("deactivateServer \(sender)")
    }
    
    override func didCommandBySelector(aSelector: Selector, client sender: AnyObject!) -> Bool {
        DDLogInfo("didCommandBySelector \(aSelector) \(sender)")
        let client = sender as! IMKTextInput
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
                    client.setMarkedText(inputBuffer, selectionRange: NSMakeRange(0, inputBuffer.characters.count), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
                    return true
                // We run out of input buffer, leave input emoji mode and clear the buffer
                } else {
                    inputBuffer = ""
                    inputEmojiMode = false
                    client.setMarkedText(inputBuffer, selectionRange: NSMakeRange(0, inputBuffer.characters.count), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
                    return true
                }
            }
        // navigate among emoji candidates
        } else if (aSelector == "moveLeft:") {
            // FIXME:
        // navigate among emoji candidates
        } else if (aSelector == "moveRight:") {
            // FIXME:
        // ESC pressed, exit emoji input mode
        } else if (aSelector == "cancelOperation:") {
            // FIXME:
        } else {
            // FIXME:
            return true
        }
        return false
    }
    
    override func commitComposition(sender: AnyObject!) {
        DDLogInfo("commitComposition \(sender)")
        let client = sender as! IMKTextInput
        // TODO: Ensure that we have an emoji to insert
        if (inputEmojiMode) {
            // FIXME: look up for the emoji and insert it
            client.insertText("💩", replacementRange: NSMakeRange(NSNotFound, NSNotFound))
        }
        inputBuffer = ""
        inputEmojiMode = false
    }
    
    override func inputText(string: String!, client sender: AnyObject!) -> Bool {
        // TODO: only log this when we are building with debug
        DDLogInfo("inputText string:\(string), client:\(sender)")
        let client = sender as! IMKTextInput
        if (string == ":" || inputEmojiMode) {
            inputEmojiMode = true
            inputBuffer.appendContentsOf(string)
            engine.keyword = extractInputKeyword()
            client.setMarkedText(inputBuffer, selectionRange: NSMakeRange(0, inputBuffer.characters.count), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
            return true
        }
        return false
    }
    
    /// Extract keyword from input buffer
    /// For example, if the input buffer is something like `:foo bar:`, then the keyword should be `foo bar`
    /// - Returns: The keyword in the input buffer, if no keyword found, an empty string will be returned
    private func extractInputKeyword() -> String! {
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
