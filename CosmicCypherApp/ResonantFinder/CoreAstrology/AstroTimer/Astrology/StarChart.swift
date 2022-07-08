//
//  StarChart.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA


class StarChart {
    
    // Functional
    var celestialOffset:Astrology.Ayanamsa = .galacticCenter
    var alignments:[Astrology.AspectBody:StarChartAlignment] = [:]
    var aspects:[StarChartAspect] = []
    var date:Date
    var coords:GeographicCoordinates
    
    init(date:Date, coords:GeographicCoordinates? = nil, celestialOffset:Astrology.Ayanamsa = .galacticCenter){
        self.date = date
        self.coords = coords ?? GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0)
        self.celestialOffset = celestialOffset
        setupAlignments()
        setupAspects()
    }
    
    private func setupAlignments() {
        for aspectBody in Astrology.AspectBody.allCases {
            
            // Pluto and isNightTime don't calculate well, so skip them.
            guard aspectBody != .pluto && aspectBody != .partOfSpirit && aspectBody != .partOfFortune && aspectBody != .partOfEros else {continue}
            
            alignments[aspectBody] = StarChartAlignment(aspectBody: aspectBody, date: date, coords: coords, ayanamsa:celestialOffset)
        }
    }
    
    private func setupAspects() {
        for (primaryKey,primaryAlignment) in alignments {
            for (secondaryKey,secondaryAlignment) in alignments where primaryKey != secondaryKey {
                
                guard !shouldSkipRedundant(primaryAlignment.aspectBody, secondaryAlignment.aspectBody) else { continue }
//
//                guard !aspects.contains(where: { (aspect) -> Bool in
//                    return aspect.secondaryBody == primaryAlignment.aspectBody && aspect.primaryBody == secondaryAlignment.aspectBody
//                }) else {
//                    continue
//                }
                let offset = abs(primaryAlignment.longitude - secondaryAlignment.longitude)
                let relation = Astrology.AspectRelation(degrees: offset)
                
                if relation != nil {
                    let aspect = StarChartAspect(primarybody: primaryAlignment.aspectBody, relation: relation!, secondaryBody: secondaryAlignment.aspectBody)
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
    
    func shouldSkipRedundant(_ first: Astrology.AspectBody, _ second: Astrology.AspectBody) -> Bool {
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
    
    private var _sortedAspects:[StarChartAspect]?
    func sortedAspects(filter:[Astrology.AspectBody]? = nil) -> [StarChartAspect] {
        
        var filteredAspects:[StarChartAspect]
        if let filter = filter {
            filteredAspects = aspects.filter({ (aspect) -> Bool in
                let isWhitelisted = aspect.relation.type != nil && filter.contains(aspect.primaryBody) && filter.contains(aspect.secondaryBody)
                
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
                    let apv = a.primaryBody.rawValue
                    let bpv = b.primaryBody.rawValue
                    
                    if apv == bpv {
                        let asv = a.secondaryBody.rawValue
                        let bsv = b.secondaryBody.rawValue

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
    
    func highestAspectConcentration(for category:Astrology.AspectRelation.AspectRelationCategory, limitList:[Astrology.AspectBody]? = nil) -> Double {
        var highestConcentration:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
            limitList?.contains(aspect.primaryBody) != false,
            limitList?.contains(aspect.secondaryBody) != false,
                aspect.relation.concentration ?? 0 > highestConcentration {
                highestConcentration = aspect.relation.concentration ?? 0
            }
        }
        return highestConcentration
    }
    
    func averageAspectConcentration(for category:Astrology.AspectRelation.AspectRelationCategory, limitList:[Astrology.AspectBody]? = nil) -> Double {
        
        
        let totalConcentration:Double = totalAspectConcentration(for: category, limitList: limitList)
        return totalConcentration / max(1,aspectCount(for: category, limitList: limitList))
    }
    
    func totalAspectConcentration(for category:Astrology.AspectRelation.AspectRelationCategory, limitList:[Astrology.AspectBody]? = nil) -> Double {
        var totalConcentration:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
            limitList?.contains(aspect.primaryBody) != false,
            limitList?.contains(aspect.secondaryBody) != false {
                totalConcentration += aspect.relation.concentration ?? 0
            }
        }
        return totalConcentration
    }
    
    func aspectCount(for category:Astrology.AspectRelation.AspectRelationCategory, limitList:[Astrology.AspectBody]? = nil) -> Double {
        var count:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
            limitList?.contains(aspect.primaryBody) != false,
            limitList?.contains(aspect.secondaryBody) != false {
                count += 1
            }
        }
        return count
    }
    
    func produceNaturaIndex(limitList:[Astrology.AspectBody]? = nil, limitType:[AstrologicalNodeType]? = nil) -> Arcana.Natura.Index {
        return Arcana.Natura.Index(alignments: self.alignments, limitList: limitList, limitType: limitType)
    }
    
    
    func produceZodiacIndex(limitList:[Astrology.AspectBody]? = nil, limitType:[AstrologicalNodeType]? = nil) -> Arcana.Zodiac.Index {
        return Arcana.Zodiac.Index(alignments: self.alignments, limitList: limitList, limitType: limitType)
    }
    
    func produceGravimetricMap() -> [String:Double] {
        var gravimetricMap:[String:Double] = [:]
        for aspectBody in Astrology.AspectBody.allCases {
            
            guard let gravity = alignments[aspectBody]?.gravity else {
                continue
            }
            gravimetricMap["\(aspectBody.rawValue)Gravity"] = gravity
        }
        return gravimetricMap
    }
    
    // For Machine Learning and Alignment Relation
    func produceAlignmentMap(planetsOnly:Bool = false) -> [String:Double] {
        var alignmentMap:[String:Double] = [:]
        for aspectBody in Astrology.AspectBody.allCases {
            
            // Pluto and isNightTime don't calculate well, so skip them.
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
    
    // For Machine Learning and Inter-aspect Computation
    func produceAspectMap() -> [String:Double] {
        var aspectMap:[String:Double] = [:]
        for primaryBody in Astrology.AspectBody.allCases {
            
            // Pluto and isNightTime don't calculate well, so skip them.
            guard primaryBody != .pluto && primaryBody != .partOfSpirit && primaryBody != .partOfFortune else {continue}
            
            for secondaryBody in Astrology.AspectBody.allCases where primaryBody != secondaryBody {

                // Pluto and isNightTime don't calculate well, so skip them.
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
    
    func duplicate(celestialOffset: Astrology.Ayanamsa? = nil) -> StarChart {
        let newStarChart = StarChart(date: self.date, coords: self.coords, celestialOffset: celestialOffset ?? self.celestialOffset)
        return newStarChart
    }
    
    // 3rd Gen Arkana Natura
    func cosmicAlignment(limitList: [Astrology.AspectBody]? = nil) -> CosmicAlignment {
        return CosmicAlignment(self, limitList: limitList)
    }
}




class StarChartAlignment:AstrologicalNode { }
class StarChartAspect:Astrology.Aspect { }


extension Astrology {
    
    enum Ayanamsa {
        case galacticCenter
        case tropical
        
        func degrees(for date:Date) -> Degree {
            switch self {
            case .galacticCenter:
                return galacticCenterOffset(for: date)
            default:
                return 0
            }
        }
        
        func galacticCenterOffset(for date:Date) -> Degree {
            let thisTimeInterval = date.timeIntervalSince1970
            let ratio = thisTimeInterval / Ayanamsa.timeIntervalBetween
            let degreesOffset = Degree((Double(ratio) * Ayanamsa.galacticDegreesBetween) + Ayanamsa.degreesAt1970)
            return degreesOffset
        }
        
        static let timeIntervalBetween:TimeInterval = {
            let startDate = Date(year: 1970, month: 1, day: 1, timeZone: TimeZone(secondsFromGMT: 0)!, hour: 1, minute: 1)!
            let endDate = Date(year: 2070, month: 1, day: 1, timeZone: TimeZone(secondsFromGMT: 0)!, hour: 1, minute: 1)!
            
            return endDate.timeIntervalSince(startDate)
        }()
        
        static let galacticDegreesBetween:Double = {
            return degreesAt2070 - degreesAt1970
        }()
        
        static let degreesAt1970:Double = 26.433333333333
        static let degreesAt2070:Double = 27.833333333333
    }
}

