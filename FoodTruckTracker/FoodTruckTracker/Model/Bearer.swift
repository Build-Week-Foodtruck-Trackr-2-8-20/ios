//
//  Bearer.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let message: String
    let role: Int
    let token: String
}
