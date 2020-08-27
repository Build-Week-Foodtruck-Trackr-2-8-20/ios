//
//  Truck+MKAnnotation.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/27/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import MapKit

extension Truck: MKAnnotation {
    /// Provides a `CLLocationCoordinate2D` based on a truck's latitude and longitude
    public var coordinate: CLLocationCoordinate2D {
        let lat = CLLocationDegrees(truckLatitude)
        let lon = CLLocationDegrees(truckLongitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    public var title: String? {
        truckName
    }
    
    public var subtitle: String? {
        cuisineType
    }
    
    /// Ensures that if a truck's longitude or latitude changes, the coordinate updates
    class func keyPathsForValuesAffectingCoordinate() -> Set<String> {
        Set<String>([#keyPath(truckLatitude), #keyPath(truckLongitude)])
    }
}
