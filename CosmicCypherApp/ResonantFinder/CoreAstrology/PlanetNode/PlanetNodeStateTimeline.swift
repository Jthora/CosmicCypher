//
//  PlanetNodeStateTimeline.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/5/22.
//

import Foundation
import SwiftAA

public typealias PlanetNodeStateTimeline = [PlanetNodeType:[PlanetNodeState]]

extension PlanetNodeStateTimeline {
    
    init(_ starCharts:[StarChart], nodeTypes:[PlanetNodeType]) {
        self = PlanetNodeStateTimeline.from(starCharts, nodeTypes: nodeTypes)
    }
    
    public static func from(_ starCharts:[StarChart], nodeTypes:[PlanetNodeType]) -> PlanetNodeStateTimeline {
        
        // Ensure StarCharts are Ordered
        let orderedStarCharts = starCharts.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        
        // Prepare PlanetNodeState List
        var planetNodeStateTimeline:PlanetNodeStateTimeline = [:]
        
        // Iterate through StarCharts
        for starChart in orderedStarCharts {
            for nodeType in nodeTypes {
                
                /// Prepare NodeState Array
                if planetNodeStateTimeline[nodeType] == nil { planetNodeStateTimeline[nodeType] = [] }
                
                /// Check Archive and Registry first
                if let planetState = try? PlanetNodeStateRegistry.main.getPlanetNodeState(starChart: starChart, nodeType: nodeType) {
                    planetNodeStateTimeline[nodeType]?.append(planetState)
                    continue
                }
                
                /// Alignment
                guard let planetNode = starChart.planetNodes[nodeType] else {continue}
                let degrees = planetNode.longitude.value
                
                
                /// Planet State
                if let planet = nodeType.planet(starChart: starChart) {
                    print("new planet state [\(nodeType.text)]")
                    
                    let perihelion = planet.longitudeOfPerihelion().value
                    let ascendingNode = planet.longitudeOfAscendingNode().value
                    let inclination = planet.inclination().value
                    let eccentricity = planet.eccentricity()
                    
                    let motion:PlanetNodeMotionState.Motion
                    let speed:Degree
                    
                    /// Retrograde and Speed
                    if let planetState = planetNodeStateTimeline[nodeType]?.last as? PlanetNodeState {
                        let lastDegrees = planetState.degrees
                        let lastMotion = planetState.motionState?.currentMotion ?? .stationary
                        if lastDegrees < degrees {
                            motion = .direct(.constant)
                        } else if lastDegrees > degrees {
                            motion = .retrograde(.constant)
                        } else {
                            motion = .stationary
                        }
                        speed = Degree(degrees - lastDegrees.degrees.value)
                    } else {
                        motion = .stationary
                        speed = 0
                    }
                    
                    // Create Motion State and Planet State
                    let motionState = PlanetNodeMotionState(motion, speed: speed)
                    let planetNodeState = PlanetNodeState(nodeType: nodeType,
                                                  date: starChart.date,
                                                  degrees: degrees,
                                                  perihelion: perihelion,
                                                  ascendingNode: ascendingNode,
                                                  inclination: inclination,
                                                  eccentricity: eccentricity,
                                                  motionState: motionState)
                    
                    // Store Planet State
                    PlanetNodeStateRegistry.main.save(planetNodeState: planetNodeState)
                    planetNodeStateTimeline[nodeType]?.append(planetNodeState)
                    
                } else {
                    // Build, Save and Append PlanetNodeState
                    guard let planetNodeState = PlanetNodeState(starChart: starChart, nodeType: nodeType) else {continue}
                    PlanetNodeStateRegistry.main.save(planetNodeState: planetNodeState)
                    planetNodeStateTimeline[nodeType]?.append(planetNodeState)
                }
            }
        }
        return planetNodeStateTimeline
    }
}

extension PlanetNodeStateTimeline {
    
    func allPlanetNodeStates() -> [PlanetNodeState] {
        var planetNodeStates = [PlanetNodeState]()
        for planetNode in self.keys {
            guard let pss = self[planetNode] else { continue }
            planetNodeStates.append(contentsOf: pss)
        }
        return planetNodeStates
    }
}

extension PlanetNodeStateTimeline {
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) throws -> PlanetNodeStateTimeline { return try JSONDecoder().decode(PlanetNodeStateTimeline.self, from: rawData) }
    public nonisolated var hashKey: String { return String(hashValue) }
}
