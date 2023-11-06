//
//  StarChartRegistry.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/29/20.
//

import Foundation
import SwiftAA

// MARK: HashKey
// Star Chart Hash Key
public typealias StarChartHashKey = String
extension StarChartHashKey {
    init(date:Date, geographicCoordinates:GeographicCoordinates) {
        self = "\(date.hashValue)_\(geographicCoordinates.longitude)_\(geographicCoordinates.latitude)_\(geographicCoordinates.altitude)"
    }
    init(point:TimeStream.Point) {
        self.init(date: point.date, geographicCoordinates: point.coordinates)
    }
}

// Get Hash Key
extension StarChart {
    var hashKey: StarChartHashKey {
        return StarChartHashKey(date: self.date, geographicCoordinates: self.coordinates)
    }
}

// MARK: Registry
// data cache + persistant store
open class StarChartRegistry {
    
    // Singleton
    public static let main:StarChartRegistry = StarChartRegistry()
    
    // Cache
    public var cache:[StarChartHashKey:StarChart] = [:]
    public func resetCache() {
        cache.removeAll()
        cacheWarningThreshold = 10000
    }
    
    // Cache Warning Delegate
    private var cacheWarningDelegates:[StarChartRegistryCacheWarningDelegate] = []
    private var cacheWarningThreshold = 10000
    public func add(cacheWarningDelegate:StarChartRegistryCacheWarningDelegate) {
        cacheWarningDelegates.append(cacheWarningDelegate)
    }
    
    // Call Cache Warning
    private func callCacheWarningDelegates() {
        for cacheWarningDelegate in cacheWarningDelegates {
            cacheWarningDelegate.cacheWarning(threshold: cacheWarningThreshold)
        }
    }
    
    // Get Star Chart
    /// from(date + coords)
    func getStarChart(date:Date, geographicCoordinates:GeographicCoordinates, onComplete:((_ starChart: StarChart)->())? = nil) throws -> StarChart {
        //let timestamp = Date()
        do {
            let hashKey = StarChartHashKey(date: date, geographicCoordinates: geographicCoordinates)
            if let starChart = getStarChart(hashKey: hashKey) {
                //print("loaded starchart from cache [\(timestamp.timeIntervalSinceNow)]")
                onComplete?(starChart)
                return starChart
            }
            if let fetchedStarChart = StarChartArchive.main.fetch(date: date, geographicCoordinates: geographicCoordinates) {
                //print("loaded starchart from archive [\(timestamp.timeIntervalSinceNow)]")
                try cache[hashKey] = fetchedStarChart
                onComplete?(fetchedStarChart)
                return fetchedStarChart
            }
            //print("generating new starchart [\(timestamp.timeIntervalSinceNow)]")
            let starChart = StarChart(date: date, coordinates: geographicCoordinates, celestialOffset: .galacticCenter) // Duh, Galactic Center.
            //print("starchart generated [\(timestamp.timeIntervalSinceNow)]")
            Task {
                try await StarChartArchive.main.store(starChart: starChart)
                //print("stored new starchart [\(timestamp.timeIntervalSinceNow)]")
            }
            cache[starChart.hashKey] = starChart
            //print("cached new starchart [\(timestamp.timeIntervalSinceNow)]")
            onComplete?(starChart)
            
            // Cache Safety
            if cache.count > cacheWarningThreshold {
                callCacheWarningDelegates()
                cacheWarningThreshold += cacheWarningThreshold
            }
            return starChart
        } catch {
            throw error
        }
    }
    
    // Get Star Chart
    /// from(point)
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

// MARK: Delegate
// Delegate Protocol
public protocol StarChartRegistryCacheWarningDelegate {
    func cacheWarning(threshold:Int)
}
