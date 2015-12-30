//
//  EditDistanceTests.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/29/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import XCTest

class EditDistanceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEditDistance() {
        XCTAssertEqual(EditDistance.distance(lhs: "foo", rhs: "foo"), 0)
        XCTAssertEqual(EditDistance.distance(lhs: "bar", rhs: ""), 3)
        XCTAssertEqual(EditDistance.distance(lhs: "", rhs: "eggs"), 4)
        XCTAssertEqual(EditDistance.distance(lhs: "kitten", rhs: "sitting"), 3)
        XCTAssertEqual(EditDistance.distance(lhs: "flaw", rhs: "lawn"), 2)
    }

}
