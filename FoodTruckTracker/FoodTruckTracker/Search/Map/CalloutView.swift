//
//  CalloutView.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/27/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class CalloutView: UIView {
    
    var cuisine: String? {
        get { return cuisineLabel.text }
        set { cuisineLabel.text = newValue }
    }
    
    var distance: String? {
        get { return distanceLabel.text }
        set { distanceLabel.text = newValue }
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
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
}
