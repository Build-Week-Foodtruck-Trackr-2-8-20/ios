//
//  Utilities.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/28/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation

extension MeasurementFormatter {
    static let shared: MeasurementFormatter = {
        let measurementForamtter = MeasurementFormatter()
        measurementForamtter.numberFormatter.maximumFractionDigits = 1
        return measurementForamtter
    }()
}
