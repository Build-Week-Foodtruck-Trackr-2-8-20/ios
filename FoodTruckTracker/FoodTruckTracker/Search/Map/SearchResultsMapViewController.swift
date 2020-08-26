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
    
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                if let newAnnotations = newValue {
                    let annotationsToRemove = currentAnnotations.filter { annotation in
                        !newAnnotations.contains { $0 === annotation }
                    }
                    mapView.removeAnnotations(annotationsToRemove)
                } else {
                    mapView.removeAnnotations(currentAnnotations)
                }
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                if let oldAnnotations = oldValue {
                    let annotationsToAdd = newAnnotations.filter { annotation in
                        !oldAnnotations.contains { $0 === annotation }
                    }
                    mapView.addAnnotations(annotationsToAdd)
                } else {
                    mapView.addAnnotations(newAnnotations)
                }
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        displayedAnnotations = fetchedResultsController?.fetchedObjects
    }
    
    // MARK: - Testing Buttons
    
    /// Adds 50 trucks to core data for testing
    @IBAction func seedTrucks(_ sender: UIButton) {
        for _ in 0..<50 {
            let lat = Double.random(in: 32 ... 34)
            let lon = Double.random(in: -82 ... -80)
            
            Truck(cuisineType: "American",
                  truckName: "WHATABURGER",
                  customerRating: 5,
                  customerRatingAvg: 5,
                  imageOfTruck: "https://www.kltv.com/resizer/or5mqVfPSUFp92P-ZnRxmQ5btds=/1200x600/cloudfront-us-east-1.images.arcpublishing.com/raycom/MR4RBHVK3JBSZOUZFXHVIFZAJY.jpeg",
                  truckLatitude: lat,
                  truckLongitude: lon)
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
            mapView.addAnnotation(truck)
        case .update:
            mapView.removeAnnotation(truck)
            mapView.addAnnotation(truck)
        case .move:
            break
        case .delete:
            mapView.removeAnnotation(truck)
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
