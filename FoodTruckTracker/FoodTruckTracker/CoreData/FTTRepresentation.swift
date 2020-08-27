//
//  FTTRepresentation.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

struct FTTRepresentation: Codable {
    var customerRatingAvg: Int16
    var customerRatings: Int16
    var itemDescription: String
    var itemName: String
    var itemPhotos: String
    var itemPrice: Double
    var email: String
    var username: String
    var favoriteTrucks: String
    var cuisineType: String
    var departureTime: Date
    var imageOfTruck: String

    enum CodingKeys: String, CodingKey {
        case customerRatingAvg
        case customerRatings = "rating"
        case itemDescription
        case itemName
        case itemPhotos = "photoURL"
        case itemPrice
        case email
        case username
        case favoriteTrucks = "userid"
        case cuisineType
        case departureTime
        case imageOfTruck = "imageURL"

    }
}
