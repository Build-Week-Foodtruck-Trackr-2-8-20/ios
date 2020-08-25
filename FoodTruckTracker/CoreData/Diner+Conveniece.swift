//
//  Diner+Conveniece.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import CoreData

extension Diner {

    @discardableResult convenience init(currentLatitude: Double,
                                        currentLongitude: Double,
                                        email: String,
                                        favoriteTrucks: String,
                                        password: String,
                                        username: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.email = email
        self.favoriteTrucks = favoriteTrucks
        self.password = password
        self.username = username
    }
}
