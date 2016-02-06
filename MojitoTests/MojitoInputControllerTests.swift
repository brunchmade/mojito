//
//  MojitoInputControllerTests.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import XCTest
import ReactiveCocoa

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
        controller.activateServer(textInput)

        // clear setMarkedTextCalls added by activate server -> reset()
        textInput.setMarkedTextCalls = []
    }
    
    override func tearDown() {
        controller.activateServer(textInput)
        super.tearDown()
    }

    func testInputEmoji() {
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
            XCTAssertEqual(textInput.setMarkedTextCalls.lastObject as? NSDictionary, [
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
        // Type ":shit:"
        let keyword = ":shit:"
        for char in keyword.characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertEqual(engine.keyword, "shit")
    }

    func testIncompleteEngineKeyword() {
        // Type ":shit"
        let keyword = ":shit"
        for char in keyword.characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertEqual(engine.keyword, "shit")
    }
    
    func testInputInsert() {
        let candidatesUpdates = MutableProperty([[EmojiCandidate]]())
        candidatesUpdates <~ server.candidates.signal.liveCollect()
        
        XCTAssertFalse(server.candidatesVisible.value)
        // Type "Hello "
        for char in "Hello ".characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertFalse(server.candidatesVisible.value)
    
        let shitEmoji = EmojiCandidate(char: Character("💩"), key: "shit")
        let smileEmoji = EmojiCandidate(char: Character("😀"), key: "smile")
        engine.candidatesToReturn = [shitEmoji, smileEmoji]
        
        // Type ":shit:"
        let keyword = ":shit:"
        for char in keyword.characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertEqual(textInput.insertTextCalls.count, 0)
        // ensure update candidates is called correctly
        XCTAssertEqual(candidatesUpdates.value.count, keyword.characters.count)
        for candidates in candidatesUpdates.value {
            XCTAssertEqual(candidates as NSArray, engine.candidatesToReturn as NSArray)
        }
        
        // Select smile emoji
        server.selectedCandidate.value = smileEmoji
    
        // Press Enter key
        XCTAssertTrue(controller.didCommandBySelector(Selector("insertNewline:"), client: textInput))
        // See if we insert the emoji
        XCTAssertEqual(textInput.insertTextCalls.count, 1)
        XCTAssertEqual(textInput.insertTextCalls.lastObject as? NSDictionary, [
            "string": "😀",
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound)
        ])
    }
    
    func testNotToSupressCommandsOutsideEmojiMode() {
        // Type "Hello "
        for char in "Hello ".characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertFalse(controller.didCommandBySelector(Selector("deleteBackward:"), client: textInput))
        XCTAssertFalse(controller.didCommandBySelector(Selector("insertNewline:"), client: textInput))
        XCTAssertFalse(controller.didCommandBySelector(Selector("moveLeft:"), client: textInput))
        XCTAssertFalse(controller.didCommandBySelector(Selector("moveRight:"), client: textInput))
        XCTAssertFalse(controller.didCommandBySelector(Selector("cancelOperation:"), client: textInput))
    }
    
    func testTypeColon() {
        // Type "::"
        for char in "::".characters {
            XCTAssertTrue(controller.inputText(String(char), client: textInput))
        }
        XCTAssertEqual(textInput.insertTextCalls.count, 1)
        XCTAssertEqual(textInput.insertTextCalls.lastObject as? NSDictionary, [
            "string": ":",
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound)
        ])
        // Type "Hello ", ensure we are out of emoji mode
        for char in "Hello ".characters {
            XCTAssertFalse(controller.inputText(String(char), client: textInput))
        }
    }
    
    func testPressEnter() {
        // Type ":)"
        for char in ":)".characters {
            XCTAssertTrue(controller.inputText(String(char), client: textInput))
        }
        // Press enter
        XCTAssertTrue(controller.didCommandBySelector(Selector("insertNewline:"), client: textInput))
        // then it should flush the input buffer
        XCTAssertEqual(textInput.insertTextCalls.count, 1)
        XCTAssertEqual(textInput.insertTextCalls.lastObject as? NSDictionary, [
            "string": ":)",
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound)
        ])
    }

    func testPressEscToSubmitInputBuffer() {
        // Type ":)"
        for char in ":)".characters {
            XCTAssertTrue(controller.inputText(String(char), client: textInput))
        }
        // Press ESC
        XCTAssertTrue(controller.didCommandBySelector(Selector("cancelOperation:"), client: textInput))
        // then it should flush the input buffer
        XCTAssertEqual(textInput.insertTextCalls.count, 1)
        XCTAssertEqual(textInput.insertTextCalls.lastObject as? NSDictionary, [
            "string": ":)",
            "replacementRange": NSMakeRange(NSNotFound, NSNotFound)
        ])
    }

    func testShowCandidateOnlyAfter2Chars() {
        // Type ":f"
        for char in ":f".characters {
            controller.inputText(String(char), client: textInput)
        }
        XCTAssertFalse(server.candidatesVisible.value)
        // Type "o"
        controller.inputText("o", client: textInput)
        XCTAssertTrue(server.candidatesVisible.value)
        
        // press backword delete
        controller.didCommandBySelector(Selector("deleteBackward:"), client: textInput)
        XCTAssertFalse(server.candidatesVisible.value)
        
    }
}
