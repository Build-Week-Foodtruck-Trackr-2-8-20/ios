//
//  TruckRepresentation.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/28/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

struct TruckRepresentation: Codable {
    var customerRatingAvg: Int16
    var customerRatings: Int16
    var cuisineType: String
    var departureTime: Date
    var imageOfTruck: String
    var truckId: Int16

    enum CodingKeys: String, CodingKey {
        case customerRatingAvg
        case customerRatings = "rating"
        case cuisineType
        case departureTime
        case imageOfTruck = "imageURL"
        case truckId = "id"
    }
}
