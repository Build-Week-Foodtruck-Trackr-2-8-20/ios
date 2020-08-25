//
//  Diner+CoreDataProperties.swift
//  
//
//  Created by Josh Kocsis on 8/24/20.
//
//

import Foundation
import CoreData


extension Diner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diner> {
        return NSFetchRequest<Diner>(entityName: "Diner")
    }

    @NSManaged public var currentLatitude: Double
    @NSManaged public var currentLongitude: Double
    @NSManaged public var email: String?
    @NSManaged public var favoriteTrucks: String?
    @NSManaged public var username: String?

}
