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
    
    var apiController: APIController?
    
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
        
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(Truck.self)
        )
        
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKUserLocation.self)
        )
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUser()
    }
    
    func showUser() {
        if let userCoordinate = mapView.userLocation.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            let region = MKCoordinateRegion(
                center: userCoordinate,
                span: span
            )
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let truck = sender as? Truck else { return }
        print(truck.title ?? "")
    }
    
    // MARK: - Public Methods
    
    /// Reloads map with current annotations from the FRC
    func reloadData() {
        guard let trucks = fetchedResultsController?.fetchedObjects else { return }
        displayedTrucks = trucks
    }
    
    // MARK: - Testing Buttons
    
    /// Adds 20 trucks to core data for testing
    @IBAction func seedTrucks(_ sender: UIButton) {
        for i in 0..<20 {
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

// MARK: - Map View Delegate

extension SearchResultsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let truck = annotation as? Truck {
            return annotationViewForTruck(truck)
        } else if let userLocation = annotation as? MKUserLocation {
            return annotationViewForUserLocation(userLocation: userLocation)
        }
        
        return nil
    }
    
    func annotationViewForUserLocation(userLocation: MKUserLocation) -> MKMarkerAnnotationView {
        guard let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: NSStringFromClass(MKUserLocation.self),
            for: userLocation) as? MKMarkerAnnotationView else {
                fatalError("Unable to cast annotationView as \(MKMarkerAnnotationView.self)")
        }
        
        annotationView.markerTintColor = .systemBlue
        annotationView.glyphImage = UIImage(systemName: "person.fill")
        
        return annotationView
    }
    
    func annotationViewForTruck(_ truck: Truck) -> MKMarkerAnnotationView {
        guard let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: NSStringFromClass(Truck.self),
            for: truck) as? MKMarkerAnnotationView else {
                fatalError("Unable to cast annotationView as \(MKMarkerAnnotationView.self)")
        }
        
        annotationView.glyphImage = UIImage(named: "Truck")
        annotationView.markerTintColor = .systemOrange
        annotationView.canShowCallout = true
        
        let calloutView = CalloutView(frame: .zero)
        
        calloutView.cuisine = truck.cuisineType
        
        let truckLocation = CLLocation(latitude: truck.coordinate.latitude,
                                       longitude: truck.coordinate.longitude)
        if let distance = mapView.userLocation.location?.distance(from: truckLocation) {
            let meters = Measurement(value: distance, unit: UnitLength.meters)
            calloutView.distance = meters.string
        }
        
        apiController?.fetchTruckImage(at: truck.imageOfTruck!) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    calloutView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
        
        annotationView.detailCalloutAccessoryView = calloutView
        
        let rightButton = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = rightButton
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let truck = view.annotation as? Truck else {
            fatalError("Only Trucks are supported as annotations at this time")
        }
        performSegue(withIdentifier: "ShowTruckDetail", sender: truck)
    }
}
