//
//  TruckController.swift
//  FoodTruckTracker
//
//  Created by Rob Vance on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import CoreData

class TruckController {
    
    let apiController = APIController()
    let context = CoreDataStack.shared.container.newBackgroundContext()
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func createTruck(truck: Truck, completion: @escaping CompletionHandler = { _ in }) {
        apiController.
    }
}
