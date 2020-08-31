//
//  FavoriteTrucksTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

protocol FavoriteTrucksDelegate: class {
    func favoritesUpdated(favorite: Truck)
}

class FavoriteTrucksTableViewCell: UITableViewCell {
    @IBOutlet private weak var truckNameLabel: UILabel!
    @IBOutlet private weak var cuisineTypeLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var starRatingStackView: StarRatingController!

    weak var delegate: FavoriteTrucksDelegate?
    static let reuseIdentifier = "FavoriteTrucks"
    var truck: Truck? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let truck = truck else { return }

        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }
        
        let df = dateFormatter.string(from: truck.departureTime!)
        truckNameLabel.text = truck.truckName
        cuisineTypeLabel.text = truck.cuisineType
        hoursLabel.text = ("\(df) - \(df)")
        delegate?.favoritesUpdated(favorite: truck)
    }
}
