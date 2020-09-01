//
//  StarRatingView.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/31/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

@IBDesignable
class StarRatingView: UIView {

    // MARK: - Properties
    
    @IBInspectable
    var value: Int = 1 { didSet { updateComponents() } }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: - Private

    private let componentDimension: CGFloat = 24
    private let componentPadding: CGFloat = 2
    private let componentCount = 5
    private var componentFlareEnabled = false
    
    private var components = [UIImageView]()
    
    private func setup() {
        var x = componentPadding
        
        for i in 1...componentCount {
            let starImage = i <= value ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            let star = UIImageView(image: starImage)
            star.contentMode = .scaleAspectFit
            
            components.append(star)
            
            addSubview(star)
            star.frame = CGRect(x: x, y: 10, width: componentDimension, height: componentDimension)
            
            x += componentDimension + componentPadding
        }
    }
    
    private func updateComponents() {
        for i in 0..<components.count {
            components[i].image = i < value ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }
    
    // MARK: - Sizing
    
    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * componentPadding
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }
}
