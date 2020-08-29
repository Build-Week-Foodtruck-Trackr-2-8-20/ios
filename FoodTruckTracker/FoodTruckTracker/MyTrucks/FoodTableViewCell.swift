//
//  FoodTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Rob Vance on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var foodItemLabel: UILabel!
    
    static let reuseIdentifier = "FoodCell"
    
    var menuItem: MenuItem? {
        didSet {
            
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
