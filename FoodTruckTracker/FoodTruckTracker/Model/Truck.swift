//
//  Truck.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/28/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

struct Trucks: Codable {
    let id: Int
    let imageURL: String
    let cuisineType: String
    let locationlocation: String
    let locationLang: Double
    let locationLat: Double
    let departureTime: Date
    let customerRatingAvg: Int
    let username: String
}
