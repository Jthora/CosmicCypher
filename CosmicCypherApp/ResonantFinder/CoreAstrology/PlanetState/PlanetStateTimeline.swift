//
//  PlanetStateTimeline.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/9/22.
//

import Foundation


public typealias PlanetStateTimeline = [CoreAstrology.AspectBody.NodeType:[PlanetState]]

extension PlanetStateTimeline {
    
    public static func from(_ starCharts:[StarChart], nodeTypes:[CoreAstrology.AspectBody.NodeType]) -> PlanetStateTimeline {
        
        // Ensure StarCharts are Ordered
        let orderedStarCharts = starCharts.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        
        // Prepare PlanetState List
        var planetStates:PlanetStateTimeline = [:]
        
        // Iterate through StarCharts
        for starChart in orderedStarCharts {
            for nodeType in nodeTypes {
                
                // Prepare
                guard let alignment = starChart.alignments[nodeType] else {continue}
                guard let planet = nodeType.planet(starChart: starChart) else {continue}
                
                let degrees = alignment.longitude.value
                
                if planetStates[nodeType] == nil { planetStates[nodeType] = [] }
                
                let perihelion = planet.longitudeOfPerihelion().value
                let ascendingNode = planet.longitudeOfAscendingNode().value
                let inclination = planet.inclination().value
                let eccentricity = planet.eccentricity()
                
                let retrogradeState:PlanetRetrogradeState
                let speed:Double
                
                // Determine Retrograde and Speed
                if let lastDegrees = planetStates[nodeType]?.last?.degrees,
                    let lastRetrogradeState = planetStates[nodeType]?.last?.retrogradeState {
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
                
                // Build PlanetState and Append
                planetStates[nodeType]?.append(planetState)
            }
        }
        return planetStates
    }
    
    func allPlanetStates() -> [PlanetState] {
        var planetStates = [PlanetState]()
        for planet in self.keys {
            guard let pss = self[planet] else { continue }
            planetStates.append(contentsOf: pss)
        }
        return planetStates
    }
}

extension PlanetStateTimeline {
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) throws -> PlanetStateTimeline { return try JSONDecoder().decode(PlanetStateTimeline.self, from: rawData) }
    public nonisolated var hashKey: String { return String(hashValue) }
}
