//
//  TimeWindow.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation


public struct TimeWindow {
    public var sampleNodes:Int
    public var start:Date
    public var end:Date
    public var timeRange:Range<Date> { return start..<end }
    
    // Duration of Time Window
    public var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    // Check if Date is within range of Time Window
    public func contains(date: Date) -> Bool {
        return timeRange.contains(date)
    }
}
