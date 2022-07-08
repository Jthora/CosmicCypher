//
//  StarChartRegistry.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 11/29/20.
//

import Foundation
import SwiftAA

// MARK: HashKey
public typealias StarChartHashKey = String
extension StarChartHashKey {
    init(date:Date, geographicCoordinates:GeographicCoordinates) {
        self = "\(date.hashValue)_\(geographicCoordinates.longitude)_\(geographicCoordinates.latitude)_\(geographicCoordinates.altitude)"
    }
    init(point:TimeStream.Point) {
        self.init(date: point.date, geographicCoordinates: point.coordinates)
    }
}

extension StarChart {
    var hashKey: StarChartHashKey {
        return StarChartHashKey(date: self.date, geographicCoordinates: self.coordinates)
    }
}

// data cache + persistant store
open class StarChartRegistry {
    
    public static let main:StarChartRegistry = StarChartRegistry()
    
    
    
    public var cache:[StarChartHashKey:StarChart] = [:]
    
    
    func getStarChart(date:Date, geographicCoordinates:GeographicCoordinates, onComplete:((_ starChart: StarChart)->())? = nil) -> StarChart {
        let timestamp = Date()
        let hashKey = StarChartHashKey(date: date, geographicCoordinates: geographicCoordinates)
        if let starChart = getStarChart(hashKey: hashKey) {
            print("loaded starchart from cache [\(timestamp.timeIntervalSinceNow)]")
            onComplete?(starChart)
            return starChart
        }
        if let starChart = StarChartArchive.main.fetch(date: date, geographicCoordinates: geographicCoordinates) {
            print("loaded starchart from archive [\(timestamp.timeIntervalSinceNow)]")
            cache[hashKey] = starChart
            onComplete?(starChart)
            return starChart
        }
        print("generating new starchart [\(timestamp.timeIntervalSinceNow)]")
        let starChart = StarChart(date: date, coordinates: geographicCoordinates, celestialOffset: .galacticCenter) // Duh, Galactic Center.
        print("starchart generated [\(timestamp.timeIntervalSinceNow)]")
        Task {
            try await StarChartArchive.main.store(starChart: starChart)
            print("stored new starchart [\(timestamp.timeIntervalSinceNow)]")
        }
        cache[starChart.hashKey] = starChart
        print("cached new starchart [\(timestamp.timeIntervalSinceNow)]")
        onComplete?(starChart)
        return starChart
    }
    
    func getStarChart(point:TimeStream.Point, onComplete:((_ starChart: StarChart)->())? = nil) -> StarChart {
        
        if let starChart = cache[StarChartHashKey(point: point)] {
            onComplete?(starChart)
            return starChart
        }
        let starChart = StarChart(date: point.date, coordinates: point.coordinates, celestialOffset: .galacticCenter) // Duh, Galactic Center.
        Task {
            try await StarChartArchive.main.store(starChart: starChart)
        }
        cache[starChart.hashKey] = starChart
        onComplete?(starChart)
        return starChart
    }
    
    func getStarChart(hashKey:StarChartHashKey) -> StarChart? {
        return cache[hashKey]
    }
}
