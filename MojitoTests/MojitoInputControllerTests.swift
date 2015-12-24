//
//  MojitoInputControllerTests.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import XCTest

class MojitoInputControllerTests: XCTestCase {
    
    var engine:MockEmojiInputEngine!
    var server:MockMojitServer!
    var textInput:MockIMKTextInput!
    var controller:MojitoInputController!

    override func setUp() {
        super.setUp()
        
        engine = MockEmojiInputEngine()
        server = MockMojitServer(engine: engine)
        textInput = MockIMKTextInput()
        controller = MojitoInputController(server: server, delegate: nil, client: textInput)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInputEmoji() {
        controller.activateServer(textInput)
        
        // Type "Hello "
        for char in "Hello ".characters {
            let result = controller.inputText(String(char), client: textInput)
            XCTAssertFalse(result)
        }
        
        XCTAssertEqual(textInput.insertTextCalls.count, 0)
        XCTAssertEqual(textInput.setMarkedTextCalls.count, 0)
        
        // Type ":"
        XCTAssertTrue(controller.inputText(":", client: textInput))
        XCTAssertEqual(textInput.insertTextCalls.count, 0)
        XCTAssertEqual(textInput.setMarkedTextCalls.count, 1)
        XCTAssertEqual(textInput.setMarkedTextCalls[0] as? NSDictionary, [
            "string": ":",
            "selectionRange": NSMakeRange(0, 1),
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound),
        ])

        // Type "poop"
        // ensure set marked texts called correctly
        let keyword = "poop"
        for (index, char) in Array(keyword.characters).enumerate() {
            let subKeywordLength = index + 1
            let subKeyword = keyword.substringWithRange(Range<String.Index>(start: keyword.startIndex, end: keyword.startIndex.advancedBy(subKeywordLength)))
            XCTAssertTrue(controller.inputText(String(char), client: textInput))
            XCTAssertEqual(textInput.setMarkedTextCalls.count, 1 + subKeywordLength)
            XCTAssertEqual(textInput.setMarkedTextCalls[subKeywordLength] as? NSDictionary, [
                "string": ":" + subKeyword,
                "selectionRange": NSMakeRange(0, 1 + index + 1),
                "replacementRange": NSMakeRange(NSNotFound, NSNotFound),
            ])
        }
        
        XCTAssertEqual(textInput.insertTextCalls.count, 0)
    }
    
    func testDeleteBackward() {
        controller.activateServer(textInput)

        // Type "Hello baby"
        for char in "Hello baby".characters {
            let result = controller.inputText(String(char), client: textInput)
            XCTAssertFalse(result)
        }
        // Delete "baby"
        for _ in 1...4 {
            // ensure these delete backward will pass through to the Input Method client
            XCTAssertFalse(controller.didCommandBySelector(Selector("deleteBackward:"), client: textInput))
            XCTAssertEqual(textInput.insertTextCalls.count, 0)
            XCTAssertEqual(textInput.setMarkedTextCalls.count, 0)
        }

        // Type ":shit"
        let inputBuffer = ":shit"
        for char in inputBuffer.characters {
            controller.inputText(String(char), client: textInput)
        }
        
        // Delete "shit" in input buffer
        for index in 1...4 {
            let currentInputBuffer = inputBuffer.substringWithRange(Range<String.Index>(start: inputBuffer.startIndex, end: inputBuffer.endIndex.advancedBy(-index)))
            // ensure we are handling these delete backward as we are current in emoji input mode
            XCTAssertTrue(controller.didCommandBySelector(Selector("deleteBackward:"), client: textInput))
            XCTAssertEqual(textInput.setMarkedTextCalls.count, inputBuffer.characters.count + index)
            XCTAssertEqual(textInput.setMarkedTextCalls[inputBuffer.characters.count + index - 1] as? NSDictionary, [
                "string": currentInputBuffer,
                "selectionRange": NSMakeRange(0, currentInputBuffer.characters.count),
                "replacementRange": NSMakeRange(NSNotFound, NSNotFound),
            ])
        }
        
        // Delete ":"
        XCTAssertTrue(controller.didCommandBySelector(Selector("deleteBackward:"), client: textInput))
        XCTAssertEqual(textInput.setMarkedTextCalls.count, inputBuffer.characters.count + 4 + 1)
        XCTAssertEqual(textInput.setMarkedTextCalls.lastObject as? NSDictionary, [
            "string": "",
            "selectionRange": NSMakeRange(0, 0),
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound),
        ])
        
        // Type "foobar"
        for char in "foobar".characters {
            let result = controller.inputText(String(char), client: textInput)
            // ensure we've already left emoji input mode
            XCTAssertFalse(result)
        }
    }
    
    func testCompleteEngineKeyword() {
        controller.activateServer(textInput)
        // Type ":shit:"
        let keyword = ":shit:"
        for char in keyword.characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertEqual(engine.keyword, "shit")
    }

    func testIncompleteEngineKeyword() {
        controller.activateServer(textInput)
        // Type ":shit"
        let keyword = ":shit"
        for char in keyword.characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertEqual(engine.keyword, "shit")
    }
    
    func testInputInsert() {
        controller.activateServer(textInput)

        // Type "Hello "
        for char in "Hello ".characters {
            controller.inputText(String(char), client: textInput)
        }

        engine.candidatesToReturn = [EmojiCandidate(
            char: Character("💩"),
            key: "shit"
        )]
        
        // Type ":shit:"
        let keyword = ":shit:"
        for char in keyword.characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertEqual(textInput.insertTextCalls.count, 0)
        // TODO: check candidates UI stuff?
        
        // Press Enter key
        XCTAssertTrue(controller.didCommandBySelector(Selector("insertNewline:"), client: textInput))
        // See if we insert the emoji
        XCTAssertEqual(textInput.insertTextCalls.count, 1)
        XCTAssertEqual(textInput.insertTextCalls.lastObject as? NSDictionary, [
            "string": "💩",
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound),
        ])
        
    }

}
