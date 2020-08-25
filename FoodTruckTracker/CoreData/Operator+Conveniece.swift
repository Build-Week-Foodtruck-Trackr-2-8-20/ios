//
//  Operator+Conveniece.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import CoreData

extension Operator {

    @discardableResult convenience init(email: String,
                                        trucksOwned: String,
                                        password: String,
                                        username: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.email = email
        self.trucksOwned = trucksOwned
        self.password = password
        self.username = username
    }
}
