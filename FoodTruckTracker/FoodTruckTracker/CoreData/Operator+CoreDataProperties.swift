//
//  Operator+CoreDataProperties.swift
//  
//
//  Created by Josh Kocsis on 8/24/20.
//
//

import Foundation
import CoreData


extension Operator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Operator> {
        return NSFetchRequest<Operator>(entityName: "Operator")
    }

    @NSManaged public var email: String?
    @NSManaged public var username: String?
    @NSManaged public var truck: NSSet?

    public var truckArray: [Truck] {
        let set = truck as? Set<Truck> ?? []
        return set.sorted {
            $0.wrappedTruck < $1.wrappedTruck
        }
    }
}

// MARK: Generated accessors for truck
extension Operator {

    @objc(addTruckObject:)
    @NSManaged public func addToTruck(_ value: Truck)

    @objc(removeTruckObject:)
    @NSManaged public func removeFromTruck(_ value: Truck)

    @objc(addTruck:)
    @NSManaged public func addToTruck(_ values: NSSet)

    @objc(removeTruck:)
    @NSManaged public func removeFromTruck(_ values: NSSet)

}
