//
//  StarChart.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA
import CoreData


public final class StarChart {
    
    // Functional
    public var date:Date
    public var coordinates:GeographicCoordinates
    public var celestialOffset:CoreAstrology.Ayanamsa = .galacticCenter
    public var planetNodes:StarChartPlanetNodes = [:]
    public var aspects:[CoreAstrology.Aspect] = []
    public var timeStreamPoint:TimeStream.Point { return TimeStream.Point(date: date, coordinates: coordinates) }
    
    
    public init(date:Date, 
                coordinates:GeographicCoordinates,
                celestialOffset:CoreAstrology.Ayanamsa = .galacticCenter, 
                planetNodes:StarChartPlanetNodes,
                aspects:[CoreAstrology.Aspect]) {
        self.date = date
        self.coordinates = coordinates
        self.celestialOffset = celestialOffset
        self.planetNodes = planetNodes
        self.aspects = aspects
    }
    
    public init(date:Date, coordinates:GeographicCoordinates? = nil, celestialOffset:CoreAstrology.Ayanamsa = .galacticCenter){
        self.date = date
        self.coordinates = coordinates ?? GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0)
        self.celestialOffset = celestialOffset
        setupPlanetNodes()
        setupAspects()
    }
    
    private func setupPlanetNodes() {
        for nodeType in CoreAstrology.AspectBody.NodeType.allCases {
            
            /// Pluto and isNightTime don't calculate well, so skip them.
            guard nodeType != .pluto && nodeType != .partOfSpirit && nodeType != .partOfFortune && nodeType != .partOfEros else {continue}
            
            planetNodes[nodeType] = PlanetNode(nodeType: nodeType,
                                              date: date,
                                              coordinates: coordinates,
                                              ayanamsa:celestialOffset)
        }
    }
    
    private func setupAspects() {
        print("StarChart: setupAspects")
        for (primaryKey,primaryPlanetNode) in planetNodes {
            //print("primaryKey: \(primaryKey)")
            
            for (secondaryKey,secondaryPanetNode) in planetNodes where primaryKey != secondaryKey {
                //print("secondaryKey: \(secondaryKey)")
                
                guard !shouldSkipRedundant(primaryPlanetNode.nodeType, secondaryPanetNode.nodeType) else { continue }
//
//                guard !aspects.contains(where: { (aspect) -> Bool in
//                    return aspect.secondaryBody == primaryAlignment.aspectBody && aspect.primaryBody == secondaryAlignment.aspectBody
//                }) else {
//                    continue
//                }
                let nodeDistance = abs(primaryPlanetNode.longitude - secondaryPanetNode.longitude)
                
                if let relation = CoreAstrology.AspectRelation(nodeDistance: nodeDistance),
                   let primaryBody = CoreAstrology.AspectBody(type: primaryPlanetNode.nodeType, date: date),
                   let secondaryBody = CoreAstrology.AspectBody(type: secondaryPanetNode.nodeType, date: date) {
                    //print("Creating Aspect: \(primaryBody.type.symbol)\(relation.type.symbol)\(secondaryBody.type.symbol) for \(date)")
                    let aspect = CoreAstrology.Aspect(primaryBody: primaryBody,
                                                      relation: relation,
                                                      secondaryBody: secondaryBody)
                    //print("Created Aspect: \(aspect.type.hash) for \(date)")
                    aspects.append(aspect)
                }
            }
        }
        
        aspects.sort { (first, second) -> Bool in
            guard let fc = first.concentration,
                let sc = second.concentration else { return false }
            return fc > sc
        }
    }
    
    public func shouldSkipRedundant(_ first: CoreAstrology.AspectBody.NodeType, _ second: CoreAstrology.AspectBody.NodeType) -> Bool {
        switch first {
        case .ascendant: if second == .decendant { return true }
        case .decendant: if second == .ascendant { return true }
        case .lunarAscendingNode: if second == .lunarDecendingNode { return true }
        case .lunarDecendingNode: if second == .lunarAscendingNode { return true }
        case .imumCoeli: if second == .midheaven { return true }
        case .midheaven: if second == .imumCoeli { return true }
        case .lunarApogee: if second == .lunarPerigee { return true }
        case .lunarPerigee: if second == .lunarApogee { return true }
        default: return false
        }
        return false
    }
    
    // TODO: IMPROVE ASPECT SORTING METHODS (multiple stort methods plz!)
    private var _sortedAspects:[CoreAstrology.Aspect]?
    public func sortedAspects(selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]? = nil,
                              selectedAspects:[CoreAstrology.AspectRelationType]? = nil) -> [CoreAstrology.Aspect] {
        
        var filteredAspects:[CoreAstrology.Aspect]
        if let selectedNodeTypes = selectedNodeTypes {
            filteredAspects = aspects.filter({ (aspect) -> Bool in
                let isWhitelisted = selectedNodeTypes.contains(aspect.primaryBody.type) && selectedNodeTypes.contains(aspect.secondaryBody.type)
                
                return isWhitelisted
            })
        } else {
            filteredAspects = aspects
        }
        
        _sortedAspects = filteredAspects.sorted(by: { (a, b) -> Bool in
            
            guard let ac = a.concentration,
                let bc = b.concentration else {return false}
            
            if ac == bc {
                let ap = a.relation.type.priority
                let bp = b.relation.type.priority
                
                if ap == bp {
                    let apv = a.primaryBody.type.rawValue
                    let bpv = b.primaryBody.type.rawValue
                    
                    if apv == bpv {
                        let asv = a.secondaryBody.type.rawValue
                        let bsv = b.secondaryBody.type.rawValue

                        return asv > bsv
                    }
                    
                    return apv > bpv
                }
                
                return ap > bp
            }
            return ac > bc
        })
        
        self._sortedAspects?.removeAll { (aspect) -> Bool in
            for otherAspect in filteredAspects {
                if aspect.shouldRemove(comparedTo: otherAspect) {
                    return true
                }
            }
            return false
        }
        
        return _sortedAspects!
        
    }
    
    public func highestAspectConcentration(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody.NodeType]? = nil) -> Double {
        var highestConcentration:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
               limitList?.contains(aspect.primaryBody.type) != false,
               limitList?.contains(aspect.secondaryBody.type) != false,
               aspect.relation.concentration > highestConcentration {
                highestConcentration = aspect.relation.concentration
            }
        }
        return highestConcentration
    }
    
    public func averageAspectConcentration(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody.NodeType]? = nil) -> Double {
        
        
        let totalConcentration:Double = totalAspectConcentration(for: category, limitList: limitList)
        return totalConcentration / max(1,aspectCount(for: category, limitList: limitList))
    }
    
    public func totalAspectConcentration(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody.NodeType]? = nil) -> Double {
        var totalConcentration:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
               limitList?.contains(aspect.primaryBody.type) != false,
               limitList?.contains(aspect.secondaryBody.type) != false {
                totalConcentration += aspect.relation.concentration
            }
        }
        return totalConcentration
    }
    
    public func aspectCount(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody.NodeType]? = nil) -> Double {
        var count:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
               limitList?.contains(aspect.primaryBody.type) != false,
               limitList?.contains(aspect.secondaryBody.type) != false {
                count += 1
            }
        }
        return count
    }
    
    // Base 8
    public func produceNaturaIndex(limitList:[CoreAstrology.AspectBody.NodeType]? = nil, limitType:[PlanetNodeSubType]? = nil) -> Arcana.Natura.Index {
        return Arcana.Natura.Index(planetNodes: self.planetNodes, limitList: limitList, limitType: limitType)
    }
    
    // Base 12
    public func produceZodiacIndex(limitList:[CoreAstrology.AspectBody.NodeType]? = nil, limitType:[PlanetNodeSubType]? = nil) -> Arcana.Zodiac.Index {
        return Arcana.Zodiac.Index(planetNodes: self.planetNodes, limitList: limitList, limitType: limitType)
    }
    
    // Base 24
    public func produceCuspIndex(limitList:[CoreAstrology.AspectBody.NodeType]? = nil, limitType:[PlanetNodeSubType]? = nil) -> Arcana.Cusp.Index {
        return Arcana.Cusp.Index(planetNodes: self.planetNodes, limitList: limitList, limitType: limitType)
    }
    
    // Base 36
    public func produceDecanIndex(limitList:[CoreAstrology.AspectBody.NodeType]? = nil, limitType:[PlanetNodeSubType]? = nil) -> Arcana.Decan.Index {
        return Arcana.Decan.Index(planetNodes: self.planetNodes, limitList: limitList, limitType: limitType)
    }
    
    public func duplicate(celestialOffset: CoreAstrology.Ayanamsa? = nil) -> StarChart {
        let newStarChart = StarChart(date: self.date, coordinates: self.coordinates, celestialOffset: celestialOffset ?? self.celestialOffset)
        return newStarChart
    }
    
    // 3rd Gen Arkana Natura
    public func cosmicAlignment(selectedNodeTypes: [CoreAstrology.AspectBody.NodeType]) -> CosmicAlignment {
        return CosmicAlignment(self, selectedNodeTypes: selectedNodeTypes)
    }
    
    public func planetNodeStates() -> [PlanetNodeStateHash:PlanetNodeState] {
        var planetNodeStates:[PlanetNodeStateHash:PlanetNodeState] = [:]
        for nodeType in CoreAstrology.AspectBody.NodeType.allCases {
            
            /// Degrees
            guard let planetNode = planetNodes[nodeType] else { continue }
            let degrees = planetNode.longitude.value
            
            /// Planet or AstrologicalNode
            if let planet = nodeType.planet(date: date, highPrecision: true) {
                
                let perihelion: Double = planet.longitudeOfPerihelion().value
                let ascendingNode: Double = planet.longitudeOfAscendingNode().value
                let inclination: Double = planet.inclination().value
                let eccentricity: Double = planet.eccentricity()
                
                // Build and Append Planet State
                let motionState = PlanetNodeMotionState(.stationary, speed: 0)
                let planetNodeState = PlanetNodeState(nodeType: nodeType,
                                                      date: date,
                                                      degrees: degrees,
                                                      perihelion: perihelion,
                                                      ascendingNode: ascendingNode,
                                                      inclination: inclination,
                                                      eccentricity: eccentricity,
                                                      motionState: motionState)
                
                // Add
                planetNodeStates[planetNodeState.hash] = planetNodeState
            } else {
                // Build, Hash and Append PlanetNodeState
                guard let planetNodeState = nodeType.generatePlanetNodeState(date: date) else {
                    continue
                }
                planetNodeStates[planetNodeState.hash] = planetNodeState
            }
        }
        return planetNodeStates
    }
//    
//    public func planetStates() -> [PlanetStateHash:PlanetState] {
//        var planetStates:[PlanetStateHash:PlanetState] = [:]
//        for nodeType in CoreAstrology.AspectBody.NodeType.allCases {
//            guard let alignment = alignments[nodeType] else { continue }
//            guard let planet = nodeType.planet(date: date, highPrecision: true) else { continue }
//            // Prepare
//            
//            let degrees = alignment.longitude.value
//            
//            let perihelion: Double = planet.longitudeOfPerihelion().value
//            let ascendingNode: Double = planet.longitudeOfAscendingNode().value
//            let inclination: Double = planet.inclination().value
//            let eccentricity: Double = planet.eccentricity()
//            
//            let retrogradeState:PlanetRetrogradeState = .direct
//            let speed:Double = 0
//            
//            // Build PlanetState and Append
//            let planetState = PlanetState(nodeType: nodeType,
//                                          date: date,
//                                          degrees: degrees,
//                                          perihelion: perihelion,
//                                          ascendingNode: ascendingNode,
//                                          inclination: inclination,
//                                          eccentricity: eccentricity,
//                                          retrogradeState: retrogradeState,
//                                          speed: speed)
//            planetStates[planetState.hashValue] = planetState
//        }
//        return planetStates
//    }
}

public typealias StarChartPlanetNodes = [CoreAstrology.AspectBody.NodeType:PlanetNode]
