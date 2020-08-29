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

//    var truckRepresentation: TruckRepresentation? {
//           guard let truckStatus =  truckStatus else { return nil }
//
//        return TruckRepresentation(cuisineType: cuisineType ?? "",
//                                   truckName: truckName,
//                                   customerRating: customerRating,
//                                   customerRatingAve: customerRatingAvg,
//                                   departureTime: departureTime!,
//                                   imageOfTruck : imageOfTruck ?? "",
//                                   truckLatitude: truckLatitude,
//                                   truckLongitude: truckLongitude,
//                                   truckId: truckId)
//       }

    @discardableResult convenience init(cuisineType: String,
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
