//
//  TruckTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Rob Vance on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class TruckTableViewCell: UITableViewCell {

    //MARK: - IBOutlets -
    // need avg star rating
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var arriveAndDepart: UISegmentedControl!
    
    static let reuseIdentifier = "TruckCell"
    
    var truck: Truck? {
        didSet {
          updateViews()
        }
    }
    
    func updateViews() {
        guard let truck = truck else { return }
        truckNameLabel.text = truck.truckName
        cuisineTypeLabel.text = truck.cuisineType
        
        let truckStatus: TruckStatus
        if let status = truck.truckStatus {
            truckStatus = TruckStatus(rawValue: status)!
        } else {
            truckStatus = .depart
        }
        arriveAndDepart.selectedSegmentIndex = TruckStatus.allCases.firstIndex(of: truckStatus) ?? 1
        arriveAndDepart.isUserInteractionEnabled = isEditing
    }
}
