//
//  AstroTimer.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/28/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

// Astro Time Delegate
public protocol AstroTimerDelegate {
    func didUpdate(_ astroTimer:AstroTimer, _ timePoint:AstroTimePoint)
}

// Astro Timer (used as a tool for scrying into StarCharts)
open class AstroTimer {
    
    // Hz
    public typealias Hz = Double
    
    // Delegate
    public var delegate:AstroTimerDelegate? = nil
    
    // Astro Time Vector
    public var timeVector:AstroTimeVector? {
        if timePointHistory.count == Int(sampleRate) {
            return AstroTimeVector(timePointA: timePointHistory.first!, timePointB: timePointHistory.last!, timescale: sampleRate.toTimeInterval())
        }
        return nil
    }
    
    // Astro Time Points
    public var timePointHistory:[AstroTimePoint] = []
    public func addTimePointToHistory(_ timePoint:AstroTimePoint) {
        timePointHistory.append(timePoint)
        if timePointHistory.count > Int(sampleRate) {
            timePointHistory.remove(at: 0)
        }
    }
    
    // Sample Rate
    /// in Hz
    public var sampleRate:Hz = 60
    
    // Filter
    /// distance range filters to define limits of how close planets must be (temporally or physically) to be added to the list of aspects
    public var filterAngleLimit:Degree?
    public var filterDistanceLimit:Meter?
    public var filterDistanceTime:TimeInterval?
    
    // Timer
    public var timer:Timer?
    private func _timerUpdate(_ timer:Timer) {
        update()
    }
    
    // Update
    public func update() {
        let timePoint = AstroTimePoint(date: Date())
        addTimePointToHistory(timePoint)
        delegate?.didUpdate(self, timePoint)
    }
    
    // Start
    public func start(_ hz:Hz? = nil) {
        guard timer?.isValid != true else { return }
        if let hz = hz { sampleRate = hz }
        timer = Timer.scheduledTimer(withTimeInterval: sampleRate.toTimeInterval(), repeats: true, block: _timerUpdate)
    }
    
    // Stop
    public func stop() {
        timer?.invalidate()
    }
    
    // Reset
    public func reset() {
        stop()
        start()
    }
}

// AstroTimer.Hz conversions
extension AstroTimer.Hz {
    public func toTimeInterval() -> TimeInterval {
        return self == 0 ? 0 : 1.0/self
    }
}
extension TimeInterval {
    public func toHz() -> AstroTimer.Hz {
        return self/1.0
    }
}

// Astro Time Vector (degrees traveled for a specific unit of time
public struct AstroTimeVector {
    public let timescale:TimeInterval
    public let moon:Degree
    public let mercury:Degree
    public let venus:Degree
    public let earth:Degree
    public let mars:Degree
    public let jupiter:Degree
    public let saturn:Degree
    public let uranus:Degree
    public let neptune:Degree
    public let pluto:Degree
    
    // Init with 2 Points
    public init(timePointA:AstroTimePoint, timePointB:AstroTimePoint, timescale:TimeInterval = 1) {
        self.timescale = timescale
        self.moon = timePointB.moon - timePointA.moon
        self.mercury = timePointB.mercury - timePointA.mercury
        self.venus = timePointB.venus - timePointA.venus
        self.earth = timePointB.earth - timePointA.earth
        self.mars = timePointB.mars - timePointA.mars
        self.jupiter = timePointB.jupiter - timePointA.jupiter
        self.saturn = timePointB.saturn - timePointA.saturn
        self.uranus = timePointB.uranus - timePointA.uranus
        self.neptune = timePointB.neptune - timePointA.neptune
        self.pluto = timePointB.pluto - timePointA.pluto
    }
}

// Astro Time Point (position at specific instance in time)
public struct AstroTimePoint {
    public let date:Date
    public let moon:Degree
    public let mercury:Degree
    public let venus:Degree
    public let earth:Degree
    public let mars:Degree
    public let jupiter:Degree
    public let saturn:Degree
    public let uranus:Degree
    public let neptune:Degree
    public let pluto:Degree
    
    // Init with Date
    public init(date:Date) {
        self.date = date
        self.moon = CoreAstronomy.moonPhaseAngle(on: date)
        self.mercury = CoreAstronomy.orbitalProgression(.mercury, on: date)!
        self.venus = CoreAstronomy.orbitalProgression(.venus, on: date)!
        self.earth = CoreAstronomy.orbitalProgression(.earth, on: date)!
        self.mars = CoreAstronomy.orbitalProgression(.mars, on: date)!
        self.jupiter = CoreAstronomy.orbitalProgression(.jupiter, on: date)!
        self.saturn = CoreAstronomy.orbitalProgression(.saturn, on: date)!
        self.uranus = CoreAstronomy.orbitalProgression(.uranus, on: date)!
        self.neptune = CoreAstronomy.orbitalProgression(.neptune, on: date)!
        self.pluto = CoreAstronomy.orbitalProgression(.pluto, on: date)!
    }
}
