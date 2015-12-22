//
//  EmojiInputController.swift
//  EmojiInput
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation
import InputMethodKit
import CocoaLumberjack

// Inherit NSObject so that this class can be used with Objective C
class EmojiInputController : NSObject {
    // String buffer for input chars
    var inputBuffer:String! = ""
    var inputEmojiMode:Bool = false;
    
    init!(server: IMKServer!, delegate: AnyObject!, client inputClient: AnyObject!) {
        super.init()
        DDLogInfo("Init EmojiInputController, server=\(server), delegate=\(delegate), client=\(inputClient)")
    }
    
    func menu() -> NSMenu! {
        DDLogInfo("menu")
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
            client.setMarkedText(inputBuffer, selectionRange: NSMakeRange(0, inputBuffer.characters.count), replacementRange: NSMakeRange(NSNotFound, NSNotFound))
            return true
        }
        return false
    }
}
