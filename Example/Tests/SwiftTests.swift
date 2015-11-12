//
//  SwiftTests.swift
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-11.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

import XCTest
import TotalObserver

class SwiftTests: XCTestCase {
    var modelObject : ModelObject! = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.modelObject = ModelObject()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testObjectNotification() {
        var sameobs : TOObservation! = nil
        let observation = self.to_observeForNotifications(self.modelObject, named: NameChangedNotification) { _, obs in
            sameobs = obs
        }
        self.modelObject.name = ""; // should trigger notification, see -[ModelObject setName]
        XCTAssert(sameobs != nil)
        XCTAssertEqual(observation, sameobs)
    }
}
