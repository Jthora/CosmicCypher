//
//  PlanetStateRegistry.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/8/22.
//

import Foundation
import SwiftAA

// MARK: Hash
public typealias PlanetStateHash = Int
extension PlanetStateHash {
    init(date: Date, planet:CoreAstrology.AspectBody.NodeType) {
        var hash = Hasher()
        hash.combine(date)
        hash.combine(planet)
        self = hash.finalize()
    }
}

public final class PlanetStateRegistry: ObservableObject {
    
    public static let main:PlanetStateRegistry = PlanetStateRegistry()
    
    @Published public var cache:[PlanetStateHash:PlanetState] = [:]
    
    
    func save(planetState:PlanetState) {
        cache[planetState.hashValue] = planetState
        Task {
            try await PlanetStateArchive.main.store(planetState: planetState)
        }
    }
    
    func getPlanetState(starChart:StarChart, nodeType:AstrologicalNodeType, onComplete:((_ planetState: PlanetState)->())? = nil) -> PlanetState? {
        if let planetState = getPlanetState(date: starChart.date, nodeType: nodeType) {
            return planetState
        } else {
            print("creating new planetState")
            let planetState = PlanetState(starChart: starChart, nodeType: nodeType)
            return planetState
        }
    }
    
    func getPlanetState(date:Date, nodeType:AstrologicalNodeType, onComplete:((_ planetState: PlanetState)->())? = nil) -> PlanetState? {
        let timestamp = Date()
        let hash = PlanetStateHash(date: date, nodeType: nodeType, subType: .body)
        if let planetState = getPlanetState(hash: hash) {
            print("loaded planetState from cache [\(timestamp.timeIntervalSinceNow)]")
            onComplete?(planetState)
            return planetState
        }
        if let planetState = PlanetStateArchive.main.fetch(date: date, nodeType: nodeType) {
            print("loaded planetState from archive [\(timestamp.timeIntervalSinceNow)]")
            cache[hash] = planetState
            onComplete?(planetState)
            return planetState
        }
        return nil
    }
    
    func getPlanetState(hash:PlanetStateHash) -> PlanetState? {
        return cache[hash]
    }
}
