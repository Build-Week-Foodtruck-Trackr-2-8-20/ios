//
//  Truck+Conveniece.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import CoreData

extension Truck {

    @discardableResult convenience init(cuisineType: String,
                                        truckName: String,
                                        customerRating: Int16,
                                        customerRatingAvg: Int16,
                                        departureTime: Date = Date(),
                                        imageOfTruck: String,
                                        truckLatitude: Double,
                                        truckLongitude: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.truckName = truckName
        self.cuisineType = cuisineType
        self.customerRating = customerRating
        self.customerRatingAvg = customerRatingAvg
        self.departureTime = departureTime
        self.imageOfTruck = imageOfTruck
        self.truckLatitude = truckLatitude
        self.truckLongitude = truckLongitude
    }
}
