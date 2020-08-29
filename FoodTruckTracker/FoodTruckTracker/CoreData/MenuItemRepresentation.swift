//
//  MenuItemRepresentation.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/28/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

struct MenuItemRepresentation: Codable {
    var customerRatingAvg: Int16
    var customerRatings: Int16
    var itemDescription: String
    var itemName: String
    var itemPhotos: String
    var itemPrice: Double
    var truckId: Int16

    enum CodingKeys: String, CodingKey {
        case customerRatingAvg
        case customerRatings = "rating"
        case itemDescription
        case itemName
        case itemPhotos = "photoURL"
        case itemPrice
        case truckId = "id"
    }
}
