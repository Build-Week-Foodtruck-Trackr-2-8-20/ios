//
//  StarRatingController.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StarRatingController: UIStackView {
    let moc = CoreDataStack.shared.mainContext
    var starRating = 0
    var starsEmpty = "star"
    var starsFilled = "starfill"

    override func draw(_ rect: CGRect) {
        let myView = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for theView in myView {
            if let theButton = theView as? UIButton {
                theButton.setImage(UIImage(named: starsEmpty), for: .normal)
                theButton.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                theButton.tag = starTag
                starTag += 1
            }
        }
    }

    @objc func pressed(sender: UIButton) {
        starRating = sender.tag
        let myView = self.subviews.filter{$0 is UIButton}
        for theView in myView {
            if let theButton = theView as? UIButton {
                if theButton.tag > sender.tag {
                    do {
                        theButton.setImage(UIImage(named: starsEmpty), for: .normal)
                        try moc.save()
                    } catch {
                        NSLog("Couldn't save rating")
                        moc.reset()
                    }
                } else {
                    do {
                        theButton.setImage(UIImage(named: starsFilled), for: .normal)
                        try moc.save()
                    } catch {
                        NSLog("Couldn't save rating")
                        moc.reset()
                    }
                }
            }
        }
    }
}
