//
//  StarCharts+DataMaps.swift
//  Project2501
//
//  Created by Jordan Trana on 4/27/22.
//

import Foundation


// MARK: Data Maps (for ML Models and Raw Data Translation)
extension StarChart {
    
    public func produceGravimetricMap() -> [String:Double] {
        var gravimetricMap:[String:Double] = [:]
        for aspectBody in CoreAstrology.AspectBody.NodeType.allCases {
            
            guard let gravity = alignments[aspectBody]?.gravity else {
                continue
            }
            gravimetricMap["\(aspectBody.rawValue)Gravity"] = gravity
        }
        return gravimetricMap
    }
    
    // For Machine Learning and Persistant Store of Alignment Relation Data
    public func produceAlignmentMap(planetsOnly:Bool = false) -> [String:Double] {
        var alignmentMap:[String:Double] = [:]
        for aspectBody in CoreAstrology.AspectBody.NodeType.allCases {
            
            /// Pluto and isNightTime don't calculate well, so skip them.
            guard aspectBody != .pluto && aspectBody != .partOfSpirit && aspectBody != .partOfFortune else {continue}
            
            guard !(planetsOnly && aspectBody.massOfPlanet() == nil) else {
                continue
            }
            guard let longitude = alignments[aspectBody]?.longitude else {
                print("Alignment Map Failed - Missing AspectBody: \(aspectBody)")
                return [:]
            }
            alignmentMap["\(aspectBody)Alignment"] = longitude.value
        }
        return alignmentMap
    }
    
    // For Machine Learning and Persistant Store of Inter-Aspect Computation Data
    public func produceAspectMap() -> [String:Double] {
        var aspectMap:[String:Double] = [:]
        for primaryBody in CoreAstrology.AspectBody.NodeType.allCases {
            
            /// Pluto and isNightTime don't calculate well, so skip them.
            guard primaryBody != .pluto && primaryBody != .partOfSpirit && primaryBody != .partOfFortune else {continue}
            
            for secondaryBody in CoreAstrology.AspectBody.NodeType.allCases where primaryBody != secondaryBody {

                /// Pluto and isNightTime don't calculate well, so skip them.
                guard secondaryBody != .pluto && secondaryBody != .partOfSpirit && secondaryBody != .partOfFortune else {continue}
                
                guard let primary = alignments[primaryBody],
                let secondary = alignments[secondaryBody] else {
                    print("Alignment Map Failed - Missing AspectBody")
                    return [:]
                }
                let offset = abs(primary.longitude - secondary.longitude)
                aspectMap["\(primaryBody)\(secondaryBody)Aspect"] = offset.value
            }
        }
        return aspectMap
    }
}
