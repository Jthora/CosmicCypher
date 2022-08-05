//
//  AstrologicalNodeStateTimeline.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/5/22.
//

import Foundation

public typealias AstrologicalNodeStateTimeline = [AstrologicalNodeType:[AstrologicalNodeState]]

extension AstrologicalNodeStateTimeline {
    
    init(_ starCharts:[StarChart], nodeTypes:[AstrologicalNodeType]) {
        self = AstrologicalNodeStateTimeline.from(starCharts, nodeTypes: nodeTypes)
    }
    
    public static func from(_ starCharts:[StarChart], nodeTypes:[AstrologicalNodeType]) -> AstrologicalNodeStateTimeline {
        
        // Ensure StarCharts are Ordered
        let orderedStarCharts = starCharts.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        
        // Prepare PlanetState List
        var nodeStates:AstrologicalNodeStateTimeline = [:]
        
        // Iterate through StarCharts
        for starChart in orderedStarCharts {
            for nodeType in nodeTypes {
                
                /// Prepare NodeState Array
                if nodeStates[nodeType] == nil { nodeStates[nodeType] = [] }
                
                /// Check Archive and Registry first
                if let planetState = try? PlanetStateRegistry.main.getPlanetState(starChart: starChart, nodeType: nodeType) {
                    nodeStates[nodeType]?.append(planetState)
                    continue
                }
                
                /// Alignment
                guard let alignment = starChart.alignments[nodeType] else {continue}
                let degrees = alignment.longitude.value
                
                
                /// Planet State
                if let planet = nodeType.planet(starChart: starChart) {
                    print("new planet state [\(nodeType.text)]")
                    
                    let perihelion = planet.longitudeOfPerihelion().value
                    let ascendingNode = planet.longitudeOfAscendingNode().value
                    let inclination = planet.inclination().value
                    let eccentricity = planet.eccentricity()
                    
                    let retrogradeState:PlanetRetrogradeState
                    let speed:Double
                    
                    /// Retrograde and Speed
                    if let planetState = nodeStates[nodeType]?.last as? PlanetState {
                        let lastDegrees = planetState.degrees
                        let lastRetrogradeState = planetState.retrogradeState ?? .direct
                        if lastDegrees < degrees {
                            retrogradeState = .direct
                        } else if lastDegrees > degrees {
                            retrogradeState = .retrograde
                        } else {
                            retrogradeState = lastRetrogradeState
                        }
                        speed = degrees - lastDegrees
                    } else {
                        retrogradeState = .direct
                        speed = 0
                    }
                    
                    let planetState = PlanetState(nodeType: nodeType,
                                                  date: starChart.date,
                                                  degrees: degrees,
                                                  perihelion: perihelion,
                                                  ascendingNode: ascendingNode,
                                                  inclination: inclination,
                                                  eccentricity: eccentricity,
                                                  retrogradeState: retrogradeState,
                                                  speed: speed)
                    
                    PlanetStateRegistry.main.save(planetState: planetState)
                    nodeStates[nodeType]?.append(planetState)
                    
                } else {
                    print("new astrological node state [\(nodeType.text)]")
                    guard let alignment = starChart.alignments[nodeType] else {continue}
                    let degrees = alignment.longitude.value
                    
                    let astrologicalNodeState = AstrologicalNodeState(nodeType: nodeType,
                                                                      subType: alignment.subType,
                                                                      date: starChart.date,
                                                                      degrees: degrees)
                    
                    // Build PlanetState and Append
                    nodeStates[nodeType]?.append(astrologicalNodeState)
                }
            }
        }
        return nodeStates
    }
    
    func allAstrologicalNodeStates() -> [AstrologicalNodeState] {
        var nodeStates = [AstrologicalNodeState]()
        for planet in self.keys {
            guard let pss = self[planet] else { continue }
            nodeStates.append(contentsOf: pss)
        }
        return nodeStates
    }
}
//
//extension AstrologicalNodeStateTimeline {
//    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
//    public nonisolated static func from(_ rawData: Data) throws -> AstrologicalNodeStateTimeline { return try JSONDecoder().decode(AstrologicalNodeStateTimeline.self, from: rawData) }
//    public nonisolated var hashKey: String { return String(hashValue) }
//}
