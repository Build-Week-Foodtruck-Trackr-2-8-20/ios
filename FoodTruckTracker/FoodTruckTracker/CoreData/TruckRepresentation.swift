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
    var truckName: String
    var truckStatus: String

    enum CodingKeys: String, CodingKey {
        case customerRatingAvg
        case customerRatings = "rating"
        case cuisineType
        case departureTime
        case imageOfTruck = "imageURL"
        case truckId = "id"
        case truckName
        case truckStatus
    }

//"id": 1,
//"imageURL": "www.amazon.com",
//"cuisineType": "Indian",
//"location": "San Francisco",
//"locationLang": null,
//"locationLat": null,
//"departureTime": "2017-01-30 16:49:19",
//"customerRatingAvg": 4,
//"username": "mj",
//"dinerRatingsArray": "2,5"
}
