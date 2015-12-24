//
//  MockIMKTextInput.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Foundation
import InputMethodKit

class MockIMKTextInput: IMKTextInput {
    var setMarkedTextCalls:NSMutableArray
    var insertTextCalls:NSMutableArray
    
    init () {
        setMarkedTextCalls = []
        insertTextCalls = []
    }
    
    @objc func setMarkedText(string: AnyObject!, selectionRange: NSRange, replacementRange: NSRange) {
        //setMarkedTextCalls.append([
        setMarkedTextCalls.addObject([
            "string": string as! NSString,
            "selectionRange": selectionRange,
            "replacementRange": replacementRange
        ])
    }
    
    @objc func insertText(string: AnyObject!, replacementRange: NSRange) {
        insertTextCalls.addObject([
            "string": string as! NSString,
            "replacementRange": replacementRange
        ])
    }
    
    @objc func selectedRange() -> NSRange {
        return NSMakeRange(0, 0)
    }
    
    @objc func markedRange() -> NSRange {
        return NSMakeRange(0, 0)
    }
    
    @objc func attributedSubstringFromRange(range: NSRange) -> NSAttributedString! {
        return NSAttributedString()
    }
    
    @objc func length() -> Int {
        return 0
    }
    
    @objc func characterIndexForPoint(point: NSPoint, tracking mappingMode: IMKLocationToOffsetMappingMode, inMarkedRange: UnsafeMutablePointer<ObjCBool>) -> Int {
        return 0
    }
    
    @objc func attributesForCharacterIndex(index: Int, lineHeightRectangle lineRect: UnsafeMutablePointer<NSRect>) -> [NSObject : AnyObject]! {
        return nil
    }
    
    @objc func validAttributesForMarkedText() -> [AnyObject]! {
        return nil
    }
    
    @objc func overrideKeyboardWithKeyboardNamed(keyboardUniqueName: String!) {
        
    }
    
    @objc func selectInputMode(modeIdentifier: String!) {
        
    }
    
    @objc func supportsUnicode() -> Bool {
        return true
    }
    
    @objc func bundleIdentifier() -> String! {
        return ""
    }
    
    @objc func windowLevel() -> CGWindowLevel {
        return CGWindowLevelKey.BaseWindowLevelKey.rawValue
    }
    
    @objc func supportsProperty(property: TSMDocumentPropertyTag) -> Bool {
        return true
    }
    
    @objc func uniqueClientIdentifierString() -> String! {
        return ""
    }
    
    @objc func stringFromRange(range: NSRange, actualRange: NSRangePointer) -> String! {
        return ""
    }
    
    @objc func firstRectForCharacterRange(aRange: NSRange, actualRange: NSRangePointer) -> NSRect {
        return NSMakeRect(0, 0, 100, 100);
    }
}