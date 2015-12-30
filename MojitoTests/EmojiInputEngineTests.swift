//
//  EmojiInputEngineTests.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/30/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import XCTest

class EmojiInputEngineTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBinarySearch() {
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: []), [])
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: ["bb"]), ["bb"])
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: ["cc"]), [])
        XCTAssertEqual(
            EmojiInputEngine.binarySearch("bb", array: ["", "a", "ab", "ac", "b", "ba", "bb", "bba", "bbc", "bcc", "d"]),
            ["bb", "bba", "bbc"]
        )
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: ["", "a", "ab", "ac", "b", "ba", "bb", "d"]), ["bb"])
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: ["", "a", "ab", "ac", "b", "ba", "d"]), [])
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: ["", "a", "ab", "ac", "b", "ba", "bb", "bba"]), ["bb", "bba"])
        XCTAssertEqual(EmojiInputEngine.binarySearch("bb", array: ["bb", "bba", "c", "cc", "ccd"]), ["bb", "bba"])
    }


}
