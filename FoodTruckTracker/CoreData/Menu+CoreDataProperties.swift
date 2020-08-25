//
//  Menu+CoreDataProperties.swift
//  
//
//  Created by Josh Kocsis on 8/24/20.
//
//

import Foundation
import CoreData


extension Menu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Menu> {
        return NSFetchRequest<Menu>(entityName: "Menu")
    }

    @NSManaged public var customerRatingAvg: Int16
    @NSManaged public var customerRatings: Int16
    @NSManaged public var itemDescription: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemPhotos: String?
    @NSManaged public var itemPrice: Double
    @NSManaged public var truck: Truck?

    public var wrappedName: String {
        itemName ?? "Unknown Item"
    }
}
