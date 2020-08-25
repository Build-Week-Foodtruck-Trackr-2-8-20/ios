//
//  Truck+CoreDataProperties.swift
//  
//
//  Created by Josh Kocsis on 8/24/20.
//
//

import Foundation
import CoreData


extension Truck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Truck> {
        return NSFetchRequest<Truck>(entityName: "Truck")
    }

    @NSManaged public var truckName: String?
    @NSManaged public var cuisineType: String?
    @NSManaged public var customerRating: Int16
    @NSManaged public var customerRatingAvg: Int16
    @NSManaged public var departureTime: Date?
    @NSManaged public var imageOfTruck: String?
    @NSManaged public var truckLatitude: Double
    @NSManaged public var truckLongitude: Double
    @NSManaged public var menu: NSSet?
    @NSManaged public var theOperator: Operator?

    public var wrappedTruck: String {
        truckName ?? "Unknown Truck"
    }

    public var menuArray: [Menu] {
        let set = menu as? Set<Menu> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for menu
extension Truck {

    @objc(addMenuObject:)
    @NSManaged public func addToMenu(_ value: Menu)

    @objc(removeMenuObject:)
    @NSManaged public func removeFromMenu(_ value: Menu)

    @objc(addMenu:)
    @NSManaged public func addToMenu(_ values: NSSet)

    @objc(removeMenu:)
    @NSManaged public func removeFromMenu(_ values: NSSet)

}
