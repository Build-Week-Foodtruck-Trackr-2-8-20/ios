//
//  FavoriteTrucksTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class FavoriteTrucksTableViewCell: UITableViewCell {
    @IBOutlet weak var truckNameLabel: UILabel!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var starRatingStackView: StarRatingController!

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
        hoursLabel.text = df
    }
}
