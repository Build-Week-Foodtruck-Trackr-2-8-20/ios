//
//  UIView+Layout.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/31/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

extension UIView {
    /// Fills the view's superview completely.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    /// - Precondition: View must be embedded in a superview.
    func fillSuperview(respectingSafeArea: Bool = false) {
        guard let superview = superview else {
            assertionFailure("\(Self.self) has no superview to fill")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if respectingSafeArea {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])
        }
    }
}
