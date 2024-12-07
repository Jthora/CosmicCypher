//
//  PlanetNodeStateRegistry.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/5/22.
//


import Foundation
import UIKit
import SwiftAA

// MARK: Hash
public typealias PlanetNodeStateHash = Int
extension PlanetNodeStateHash {
    init(date:Date, nodeType:PlanetNodeType) {
        var hasher = Hasher()
        hasher.combine(nodeType.hashValue)
        hasher.combine(date.hashValue)
        self = hasher.finalize()
    }
}


// data cache + persistant store
open class PlanetNodeStateRegistry {
    
    public static let main:PlanetNodeStateRegistry = PlanetNodeStateRegistry()
    
    public var cache:[PlanetNodeStateHash:PlanetNodeState] = [:]
    
    func getPlanetNodeState(starChart:StarChart, nodeType:PlanetNodeType, onComplete:((_ planetNodeState: PlanetNodeState)->())? = nil) throws -> PlanetNodeState {
        let timestamp = Date()
        let hash = PlanetNodeStateHash(date: starChart.date,
                                       nodeType: nodeType)
        
        // Fetch from Cache
        if let planetNodeState = getPlanetNodeState(hash: hash) {
            onComplete?(planetNodeState)
            return planetNodeState
        }
        
        // Fetch from Persistant Store
        if let planetNodeState = PlanetNodeStateArchive.main.fetch(date: starChart.date, nodeType: nodeType, subType: nodeType.subType) {
            cache[hash] = planetNodeState
            onComplete?(planetNodeState)
            return planetNodeState
        }
        
        // Create New
        /// Alignment
        guard let alignment = starChart.planetNodes[nodeType] else {
            throw PlanetNodeStateRegistryError.runtimeError("no alignments for starchart")
        }
        /// Planet Node State
        guard let planetNodeState = PlanetNodeState(starChart: starChart,
                                              nodeType: nodeType,
                                              motionState: nil) else {
            throw PlanetNodeStateRegistryError.runtimeError("no PlanetNodeState for starchart")
        }
        
        // Persistant Store
        Task {
            try await PlanetNodeStateArchive.main.store(planetNodeState: planetNodeState)
        }
        
        // Add to Cache
        cache[hash] = planetNodeState
        
        // Complete and Return
        onComplete?(planetNodeState)
        return planetNodeState
    }
    
    // MARK: Get Planet Node State
    func getPlanetNodeState(date:Date, nodeType:PlanetNodeType, subType:PlanetNodeSubType, onComplete:((_ planetNodeState: PlanetNodeState)->())? = nil) throws -> PlanetNodeState? {
        
        // Properties
        let timestamp = Date()
        let hash = PlanetNodeStateHash(date: date, nodeType: nodeType)
        
        // Node Stage from Memory Cache
        if let planetNodeState = cache[hash] {
            print("loaded planetNodeState from cache [\(timestamp.timeIntervalSinceNow)]")
            onComplete?(planetNodeState)
            return planetNodeState
        }
        
        // Node State from Disk Drive
        if let planetNodeState = PlanetNodeStateArchive.main.fetch(date: date, nodeType: nodeType, subType: subType) {
            cache[hash] = planetNodeState
            onComplete?(planetNodeState)
            return planetNodeState
        }
        
        // Create New
        /// Star Chart
        guard let starChart = try? StarChartRegistry.main.getStarChart(date: date, geographicCoordinates: .zero) else {
            throw PlanetNodeStateRegistryError.runtimeError("no alignments for starchart")
        }
        /// Alignment
        guard let alignment = starChart.planetNodes[nodeType] else {
            throw PlanetNodeStateRegistryError.runtimeError("no alignments for starchart")
        }
        /// Planet Node State
        guard let planetNodeState = PlanetNodeState(starChart: starChart,
                                              nodeType: nodeType,
                                              motionState: nil) else {
            throw PlanetNodeStateRegistryError.runtimeError("no PlanetNodeState for starchart")
        }
                
        // Persistant Store
        Task {
            try await PlanetNodeStateArchive.main.store(planetNodeState: planetNodeState)
        }
        
        // Add to Cache
        cache[hash] = planetNodeState
        
        // Complete and Return
        onComplete?(planetNodeState)
        return planetNodeState
    }
    
    func getPlanetNodeState(hash:PlanetNodeStateHash) -> PlanetNodeState? {
        return cache[hash]
    }

    func save(planetNodeState:PlanetNodeState) {
        cache[planetNodeState.hashValue] = planetNodeState
        Task {
            try await PlanetNodeStateArchive.main.store(planetNodeState: planetNodeState)
        }
    }
}

enum PlanetNodeStateRegistryError: Error {
    case runtimeError(String)
}

//
//// MARK: Hash
//public typealias PlanetStateHash = Int
//extension PlanetStateHash {
//    init(date: Date, planet:CoreAstrology.AspectBody.NodeType) {
//        var hash = Hasher()
//        hash.combine(date)
//        hash.combine(planet)
//        self = hash.finalize()
//    }
//}
//
//public final class PlanetStateRegistry: ObservableObject {
//
//    public static let main:PlanetStateRegistry = PlanetStateRegistry()
//
//    @Published public var cache:[PlanetStateHash:PlanetState] = [:]
//
//
//
//    func getPlanetState(starChart:StarChart, nodeType:AstrologicalNodeType, onComplete:((_ planetState: PlanetState)->())? = nil) -> PlanetState? {
//        if let planetState = getPlanetState(date: starChart.date, nodeType: nodeType) {
//            return planetState
//        } else {
//            //print("creating new planetState")
//            let planetState = PlanetState(starChart: starChart, nodeType: nodeType)
//            return planetState
//        }
//    }
//
//    func getPlanetState(date:Date, nodeType:AstrologicalNodeType, onComplete:((_ planetState: PlanetState)->())? = nil) -> PlanetState? {
//        let timestamp = Date()
//        let hash = PlanetStateHash(date: date, nodeType: nodeType, subType: .body)
//        if let planetState = getPlanetState(hash: hash) {
//            print("loaded planetState from cache [\(timestamp.timeIntervalSinceNow)]")
//            onComplete?(planetState)
//            return planetState
//        }
//        if let planetState = PlanetStateArchive.main.fetch(date: date, nodeType: nodeType) {
//            print("loaded planetState from archive [\(timestamp.timeIntervalSinceNow)]")
//            cache[hash] = planetState
//            onComplete?(planetState)
//            return planetState
//        }
//        return nil
//    }
//
//    func getPlanetState(hash:PlanetStateHash) -> PlanetState? {
//        return cache[hash]
//    }
//}
