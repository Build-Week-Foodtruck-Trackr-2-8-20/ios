//
//  Truck+Conveniece.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import CoreData

enum TruckStatus: String, CaseIterable {
    case arrive
    case depart
}

extension Truck {

    @discardableResult convenience init(cuisineType: String,
                                        truckStatus: TruckStatus = .arrive,
                                        truckName: String,
                                        customerRating: Int16,
                                        customerRatingAvg: Int16,
                                        departureTime: Date = Date(),
                                        imageOfTruck: String,
                                        truckLatitude: Double,
                                        truckLongitude: Double,
                                        truckId: Int,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.truckStatus = truckStatus.rawValue
        self.truckName = truckName
        self.cuisineType = cuisineType
        self.customerRating = customerRating
        self.customerRatingAvg = customerRatingAvg
        self.departureTime = departureTime
        self.imageOfTruck = imageOfTruck
        self.truckLatitude = truckLatitude
        self.truckLongitude = truckLongitude
        self.truckId = Int16(truckId)
    }
}
