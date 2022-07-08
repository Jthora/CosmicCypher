//
//  JulianDay+Extension.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/25/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

extension JulianDay {
    
    // Compare Greater or Less Than for date comparison
    public func isAfter(_ otherDay:JulianDay) -> Bool {
        return self.date.timeIntervalSince(otherDay.date) > 0
    }
    
    public func isBefore(_ otherDay:JulianDay) -> Bool {
        return self.date.timeIntervalSince(otherDay.date) < 0
    }
}
