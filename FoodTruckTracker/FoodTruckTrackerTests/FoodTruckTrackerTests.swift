//
//  FoodTruckTrackerTests.swift
//  FoodTruckTrackerTests
//
//  Created by Josh Kocsis on 8/19/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import XCTest
@testable import FoodTruckTracker

class FoodTruckTrackerTests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignUp() {
        let apiController = APIController()
        let user = User(username: "Jkocsis", password: "Jkocsis", email: "josh.s.kocsis@gmail.com", role: 1, id: 1)
        apiController.registerUser(with: user)
        apiController.loginUser(with: user)

        XCTAssert(user.email == "josh.s.kcosis@gmail.com")
        
    }
}
