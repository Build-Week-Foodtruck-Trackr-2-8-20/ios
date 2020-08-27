//
//  SearchResultsMapViewController.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class SearchResultsMapViewController: UIViewController {
    // MARK: - Public Properties
    
    var fetchedResultsController: NSFetchedResultsController<Truck>? {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var mapView: MKMapView!
    
    // MARK: - Private Properties
    
    /// Updates the truck annotations displayed by the mapView.
    /// Only deletes and adds trucks that have changed.
    private var displayedTrucks: [Truck] = [] {
        willSet {
            let annotationsToRemove = displayedTrucks.filter { truck in
                !newValue.contains(truck)
            }
            mapView.removeAnnotations(annotationsToRemove)
        }
        didSet {
            let annotationsToAdd = displayedTrucks.filter { truck in
                !oldValue.contains(truck)
            }
            mapView.addAnnotations(annotationsToAdd)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods
    
    /// Reloads map with current annotations from the FRC
    func reloadData() {
        guard let trucks = fetchedResultsController?.fetchedObjects else { return }
        displayedTrucks = trucks
    }
    
    // MARK: - Testing Buttons
    
    /// Adds 50 trucks to core data for testing
    @IBAction func seedTrucks(_ sender: UIButton) {
        for i in 0..<50 {
                let lat = Double.random(in: 32 ... 34)
                let lon = Double.random(in: -82 ... -80)
                Truck(cuisineType: "American",
                      truckName: "WHATABURGER",
                      customerRating: 5,
                      customerRatingAvg: 5,
                      imageOfTruck: """
                      https://www.kltv.com/resizer/or5mqVfPSUFp92P-ZnRxmQ5btds=/1200x600/cloudfront-us-east-1.\
                      images.arcpublishing.com/raycom/MR4RBHVK3JBSZOUZFXHVIFZAJY.jpeg
                      """,
                      truckLatitude: lat,
                      truckLongitude: lon,
                      truckId: i)
            }
            try? CoreDataStack.shared.save()
        }
    
    /// Removes all currently fetched trucks from core data
    @IBAction func deleteTrucks(_ sender: UIButton) {
        guard let trucks = fetchedResultsController?.fetchedObjects else { return }
        
        for truck in trucks {
            CoreDataStack.shared.mainContext.delete(truck)
        }
        try? CoreDataStack.shared.save()
    }
}

// MARK: - Fetched Results Controller Delegate

extension SearchResultsMapViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let truck = anObject as? Truck else { return }
    
        switch type {
        case .insert:
            displayedTrucks.append(truck)
        case .update:
            if let index = displayedTrucks.firstIndex(of: truck) {
                displayedTrucks.remove(at: index)
                displayedTrucks.append(truck)
            }
        case .move:
            break
        case .delete:
            if let index = displayedTrucks.firstIndex(of: truck) {
                displayedTrucks.remove(at: index)
            }
        @unknown default:
            break
        }
    }
}

// MARK: - Truck MKAnnotation Conformance

extension Truck: MKAnnotation {
    /// Provides a `CLLocationCoordinate2D` based on a truck's latitude and longitude
    public var coordinate: CLLocationCoordinate2D {
        let lat = CLLocationDegrees(truckLatitude)
        let lon = CLLocationDegrees(truckLongitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    /// Ensures that if a truck's longitude or latitude changes, the coordinate updates
    class func keyPathsForValuesAffectingCoordinate() -> Set<String> {
        Set<String>([#keyPath(truckLatitude), #keyPath(truckLongitude)])
    }
}
