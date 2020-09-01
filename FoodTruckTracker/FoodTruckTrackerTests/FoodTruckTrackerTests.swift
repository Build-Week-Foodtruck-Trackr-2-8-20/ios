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
    let apiController = APIController()
    var trucks: Truck?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignUp() {
        let user = User(username: "Jkocsis",
                        password: "Jkocsis",
                        email: "josh.s.kocsis@gmail.com",
                        role: 1,
                        id: 1)

        apiController.registerUser(with: user)
        apiController.loginUser(with: user)

        XCTAssert(user.email == "josh.s.kcosis@gmail.com")
        
    }

    func testFetchAllUsers() {
        let user = User(username: "Jkocsis",
                        password: "Jkocsis",
                        email: "josh.s.kocsis@gmail.com",
                        role: 1,
                        id: 1)
        let user1 = User(username: "Jkocsis1",
                         password: "Jkocsis1",
                         email: "josh.s.kocsis1@gmail.com",
                         role: 1,
                         id: 2)
        let user2 = User(username: "Jkocsis2",
                         password: "Jkocsis2",
                         email: "josh.s.kocsis2@gmail.com",
                         role: 1,
                         id: 3)

        apiController.registerUser(with: user)
        apiController.registerUser(with: user1)
        apiController.registerUser(with: user2)
        apiController.fetchAllUsers()

        XCTAssert(user.username == "Jkocsis")
        XCTAssert(user1.username == "Jkocsis1")
        XCTAssert(user2.username == "Jkocsis2")

        XCTAssertFalse(user.username == "Jkocsis2")
        XCTAssertFalse(user1.username == "Jkocsis")
        XCTAssertFalse(user2.username == "Jkocsis1")
    }

    func testUserLoggedIn() {
        let user = User(username: "Jkocsis",
                        password: "Jkocsis",
                        email: "josh.s.kocsis@gmail.com",
                        role: 1,
                        id: 1)
        let user1 = User(username: "Jkocsis1",
                         password: "Jkocsis1",
                         email: "josh.s.kocsis1@gmail.com",
                         role: 1,
                         id: 2)
        let user2 = User(username: "Jkocsis2",
                         password: "Jkocsis2",
                         email: "josh.s.kocsis2@gmail.com",
                         role: 1,
                         id: 3)

        apiController.registerUser(with: user)
        apiController.registerUser(with: user1)
        apiController.registerUser(with: user2)
        apiController.loginUser(with: user)
        let loggedIn = user.id

        XCTAssertTrue(loggedIn == 1)
        XCTAssertFalse(loggedIn == 2)
    }

    func testTruckName() {

        let truck = Truck(cuisineType: "Spanish",
                          truckName: "Conquistador",
                          customerRating: 4,
                          customerRatingAvg: 3,
                          imageOfTruck: "",
                          truckLatitude: 40.3,
                          truckLongitude: -44.8,
                          truckId: 1)
        let truck1 = Truck(cuisineType: "French",
                           truckName: "Septime",
                           customerRating: 5,
                           customerRatingAvg: 4,
                           imageOfTruck: "",
                           truckLatitude: 49.6,
                           truckLongitude: -38.2,
                           truckId: 2)

        apiController.fetchAllTrucksWithRating(for: "4")

        XCTAssert(truck.truckName == "Conquistador")
        XCTAssertFalse(truck.truckName == "Septime")
    }

    func testTruckID() {

        let truck = Truck(cuisineType: "Spanish",
                          truckName: "Conquistador",
                          customerRating: 4,
                          customerRatingAvg: 3,
                          imageOfTruck: "",
                          truckLatitude: 40.3,
                          truckLongitude: -44.8,
                          truckId: 1)
        let truck1 = Truck(cuisineType: "French",
                           truckName: "Septime",
                           customerRating: 5,
                           customerRatingAvg: 4,
                           imageOfTruck: "",
                           truckLatitude: 49.6,
                           truckLongitude: -38.2,
                           truckId: 2)

        apiController.fetchAllTrucksWithRating(for: "5")

        XCTAssertFalse(truck1.truckId == 1)
        XCTAssert(truck1.truckId == 2)
    }

    func testFailingTruckCuisineType() {

        let truck = Truck(cuisineType: "Spanish",
                          truckName: "Conquistador",
                          customerRating: 4,
                          customerRatingAvg: 3,
                          imageOfTruck: "",
                          truckLatitude: 40.3,
                          truckLongitude: -44.8,
                          truckId: 1)
        let truck1 = Truck(cuisineType: "French",
                           truckName: "Septime",
                           customerRating: 5,
                           customerRatingAvg: 4,
                           imageOfTruck: "",
                           truckLatitude: 49.6,
                           truckLongitude: -38.2,
                           truckId: 2)

        apiController.fetchAllTrucksWithRating(for: "4")

        XCTAssert(truck.cuisineType == "French")
    }

    func testFailingUserLogin() {
        let user = User(username: "Jkocsis",
                        password: "Jkocsis",
                        email: "josh.s.kocsis@gmail.com",
                        role: 1,
                        id: 1)
        let user1 = User(username: "Jkocsis1",
                         password: "Jkocsis1",
                         email: "josh.s.kocsis1@gmail.com",
                         role: 1,
                         id: 2)
        let user2 = User(username: "Jkocsis2",
                         password: "Jkocsis2",
                         email: "josh.s.kocsis2@gmail.com",
                         role: 1,
                         id: 3)

        apiController.registerUser(with: user)
        apiController.registerUser(with: user1)
        apiController.registerUser(with: user2)
        apiController.loginUser(with: user)


        XCTAssert(user.id == 3)
    }

    func testFailingFetchAllTrucks() {

        let truck = Truck(cuisineType: "Spanish",
                          truckName: "Conquistador",
                          customerRating: 4,
                          customerRatingAvg: 3,
                          imageOfTruck: "",
                          truckLatitude: 40.3,
                          truckLongitude: -44.8,
                          truckId: 1)
        let truck1 = Truck(cuisineType: "French",
                           truckName: "Septime",
                           customerRating: 5,
                           customerRatingAvg: 4,
                           imageOfTruck: "",
                           truckLatitude: 49.6,
                           truckLongitude: -38.2,
                           truckId: 2)

        apiController.fetchAllTrucksWithRating(for: "")

        XCTAssert(truck.truckName == "")
    }

    func testTime() {
        guard let trucks = trucks else { return }

        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }

        let df = dateFormatter.string(from: trucks.departureTime!)

        XCTAssert(df == "\(df)")
    }

    func timeFails() {
        guard let trucks = trucks else { return }

        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }

        let df = dateFormatter.string(from: trucks.departureTime!)

        XCTAssertFalse(df == "hh.mm.ss")
    }
}
