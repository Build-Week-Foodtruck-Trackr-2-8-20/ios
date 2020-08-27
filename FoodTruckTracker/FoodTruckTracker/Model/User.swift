//
//  User.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let email: String
    let role: Int
    let id: Int
}
