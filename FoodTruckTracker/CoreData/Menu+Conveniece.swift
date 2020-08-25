//
//  Menu+Conveniece.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import CoreData

extension Menu {

    @discardableResult convenience init(customerRatingAvg: Int16,
                                        customerRatings: Int16,
                                        itemDescription: String,
                                        itemName: String,
                                        itemPhotos: String,
                                        itemPrice: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.customerRatingAvg = customerRatingAvg
        self.customerRatings = customerRatings
        self.itemDescription = itemDescription
        self.itemName = itemName
        self.itemPhotos = itemPhotos
        self.itemPrice = itemPrice
    }
}
