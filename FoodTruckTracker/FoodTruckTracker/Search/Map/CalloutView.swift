//
//  CalloutView.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/27/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import MapKit
import UIKit

class CalloutView: UIView {
    
    var userLocation: MKUserLocation? {
        didSet {
            updateDistanceLabel()
        }
    }
    
    var truck: Truck? {
        didSet {
            updateViews()
            updateDistanceLabel()
        }
    }

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var cuisineLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("CalloutView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func updateViews() {
        guard let truck = truck,
              let imageOfTruck = truck.imageOfTruck else { return }
        
        // TODO: Proper call to fetch image using APIController
        if let imageURL = URL(string: imageOfTruck),
           let imageData = try? Data(contentsOf: imageURL) {
            imageView.image = UIImage(data: imageData)
        }
        
        cuisineLabel.text = truck.cuisineType
    }
    
    private func updateDistanceLabel() {
        guard let truck = truck,
              let userLocation = userLocation else { return }
        let truckLocation = CLLocation(latitude: truck.coordinate.latitude,
                                       longitude: truck.coordinate.longitude)
        guard let distance = userLocation.location?.distance(from: truckLocation) else {
            return
        }
        
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        distanceLabel.text = MeasurementFormatter.shared.string(from: meters)
    }
}
