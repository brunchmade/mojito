//
//  NSAttributedStringHyperLink.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/10/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation

extension NSAttributedString {
    class func hyperlink(string:String, url:NSURL) -> NSAttributedString {
        let attrStr = NSMutableAttributedString(string: string)
        attrStr.beginEditing()
        attrStr.addAttributes(
            [
                NSLinkAttributeName: url.absoluteString,
                NSForegroundColorAttributeName: NSColor.blueColor(),
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
            ],
            range: NSMakeRange(0, string.characters.count)
        )
        attrStr.endEditing()
        return attrStr
    }
}