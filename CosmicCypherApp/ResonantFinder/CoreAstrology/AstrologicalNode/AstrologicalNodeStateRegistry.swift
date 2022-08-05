//
//  AstrologicalNodeStateRegistry.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/5/22.
//


import Foundation
import UIKit
import SwiftAA

// MARK: Hash
public typealias AstrologicalNodeStateHash = Int
extension AstrologicalNodeStateHash {
    init(date:Date, nodeType:AstrologicalNodeType, subType:AstrologicalNodeSubType) {
        var hasher = Hasher()
        hasher.combine(nodeType.hashValue)
        hasher.combine(subType.hashValue)
        hasher.combine(date.hashValue)
        self = hasher.finalize()
    }
}


// data cache + persistant store
open class AstrologicalNodeStateRegistry {
    
    public static let main:AstrologicalNodeStateRegistry = AstrologicalNodeStateRegistry()
    
    public var cache:[AstrologicalNodeStateHash:AstrologicalNodeState] = [:]
    
    func getAstrologicalNodeState(starChart:StarChart, nodeType:AstrologicalNodeType, subType:AstrologicalNodeSubType, onComplete:((_ astrologicalNodeState: AstrologicalNodeState)->())? = nil) throws -> AstrologicalNodeState {
        let timestamp = Date()
        let hash = AstrologicalNodeStateHash(date: starChart.date,
                                             nodeType: nodeType,
                                             subType: subType)
        if let nodeState = getAstrologicalNodeState(hash: hash) {
            print("loaded nodeState from cache [\(timestamp.timeIntervalSinceNow)]")
            onComplete?(nodeState)
            return nodeState
        }
        if let nodeState = AstrologicalNodeStateArchive.main.fetch(date: starChart.date, nodeType: nodeType, subType: subType) {
            print("loaded nodeState from archive [\(timestamp.timeIntervalSinceNow)]")
            cache[hash] = nodeState
            onComplete?(nodeState)
            return nodeState
        }
        print("generating new nodeState [\(timestamp.timeIntervalSinceNow)]")
        guard let alignment = starChart.alignments[nodeType] else {throw AstrologicalNodeStateRegistryError.runtimeError("no alignments for starchart")}
        let degrees = alignment.longitude.value
        let nodeState = AstrologicalNodeState(nodeType: nodeType, subType: subType, date: starChart.date, degrees: degrees) // Duh, Galactic Center.
        print("nodeState generated [\(timestamp.timeIntervalSinceNow)]")
        Task {
            try await AstrologicalNodeStateArchive.main.store(astrologicalNodeState: nodeState)
            print("stored new nodeState [\(timestamp.timeIntervalSinceNow)]")
        }
        cache[hash] = nodeState
        print("cached new nodeState [\(timestamp.timeIntervalSinceNow)]")
        onComplete?(nodeState)
        return nodeState
    }
    
    func getAstrologicalNodeState(date:Date, nodeType:AstrologicalNodeType, subType:AstrologicalNodeSubType, onComplete:((_ astrologicalNodeState: AstrologicalNodeState)->())? = nil) throws -> AstrologicalNodeState {
        let timestamp = Date()
        let hash = AstrologicalNodeStateHash(date: date,
                                             nodeType: nodeType,
                                             subType: subType)
        if let nodeState = cache[hash] {
            print("loaded nodeState from cache [\(timestamp.timeIntervalSinceNow)]")
            onComplete?(nodeState)
            return nodeState
        }
        if let nodeState = AstrologicalNodeStateArchive.main.fetch(date: date, nodeType: nodeType, subType: subType) {
            print("loaded nodeState from archive [\(timestamp.timeIntervalSinceNow)]")
            cache[hash] = nodeState
            onComplete?(nodeState)
            return nodeState
        }
        print("generating new nodeState [\(timestamp.timeIntervalSinceNow)]")
        guard let alignment = StarChartRegistry.main.getStarChart(date: date, geographicCoordinates: .zero).alignments[nodeType] else {throw AstrologicalNodeStateRegistryError.runtimeError("no alignments for starchart")}
        let degrees = alignment.longitude.value
        let nodeState = AstrologicalNodeState(nodeType: nodeType, subType: subType, date: date, degrees: degrees) // Duh, Galactic Center.
        print("nodeState generated [\(timestamp.timeIntervalSinceNow)]")
        Task {
            try await AstrologicalNodeStateArchive.main.store(astrologicalNodeState: nodeState)
            print("stored new nodeState [\(timestamp.timeIntervalSinceNow)]")
        }
        cache[hash] = nodeState
        print("cached new nodeState [\(timestamp.timeIntervalSinceNow)]")
        onComplete?(nodeState)
        return nodeState
    }
    
    func getAstrologicalNodeState(hash:AstrologicalNodeStateHash) -> AstrologicalNodeState? {
        return cache[hash]
    }
}

enum AstrologicalNodeStateRegistryError: Error {
    case runtimeError(String)
}
