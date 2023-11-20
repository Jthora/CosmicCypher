//
//  Decan+Index.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/14/23.
//

import Foundation


extension Arcana.Decan {
    
    public class Level {
        var power:Double = 0
        var unlock:Double = 0
        var distribution:Double = 0
        var subDistribution:Double = 0
    }
    
    public class Index {
        
        public var count:Double = 0
        public var powerCount:Double = 0
        
        // Decan Levels
        public var decanLevels:[Arcana.Decan:Level] {
            get {
                return _base32Levels
            }
        }
        private var _base32Levels:[Arcana.Decan:Level] = {
            let decans = Arcana.Decan.allCases
            var base32 = [Arcana.Decan:Level]()
            for decan in decans {
                base32[decan] = Level()
            }
            return base32
        }()
        func level(for decan: Arcana.Decan) -> Level {
            return decanLevels[decan]!
        }
        
        public var totalPower:Double {
            var total:Double = 0
            for decan in Arcana.Decan.allCases {
                total += self.power(for: decan)
            }
            return total
        }
        
        public var totalUnlock:Double {
            var total:Double = 0
            for decan in Arcana.Decan.allCases {
                total += self.unlock(for: decan)
            }
            return total
        }
        
        public var total:Double {
            return totalPower + totalUnlock
        }
        
        public var average:Double {
            return total / Double(Arcana.Decan.allCases.count)
        }
        
        public init(planetNodes: [CoreAstrology.AspectBody.NodeType:PlanetNode], limitList:[CoreAstrology.AspectBody.NodeType]? = nil , limitType:[PlanetNodeSubType]? = nil) {
            
            
            for (_,planetNode) in planetNodes {
                
                if let limitList = limitList {
                    guard limitList.contains(planetNode.nodeType) else { continue }
                }
                
                if let limitType = limitType {
                    guard limitType.contains(planetNode.nodeType.subType) else { continue }
                }
                
                let chevron = planetNode.createChevron()
                // Distribution
                add(distribution: chevron.decanDistribution, to: chevron.decan)
                add(subDistribution: chevron.subDecanDistribution, to: chevron.subDecan)
                
                count += 1
            }
        }
        
        
        // Add
        public func add(power:Double, to decan:Arcana.Decan) {
            self.level(for: decan).power += power
        }
        
        public func add(unlock:Double, to decan:Arcana.Decan) {
            self.level(for: decan).unlock += unlock
        }
        
        public func add(distribution:Double, to decan:Arcana.Decan) {
            self.level(for: decan).distribution += distribution
        }
        
        public func add(subDistribution:Double, to decan:Arcana.Decan) {
            self.level(for: decan).subDistribution += subDistribution
        }
        
        // Get
        public func power(for decan:Arcana.Decan, normalized:Bool = false) -> Double {
            let level = self.level(for: decan)
            let power = normalized ? level.power/total : level.power
            return power
        }
        
        public func unlock(for decan:Arcana.Decan, normalized:Bool = false) -> Double {
            let level = self.level(for: decan)
            let unlock = normalized ? level.unlock/total : level.unlock
            return unlock
        }
        
        public func distribution(for decan:Arcana.Decan, normalized:Bool = false) -> Double {
            let level = self.level(for: decan)
            let distribution = normalized ? level.distribution/total : level.distribution
            return distribution
        }
        
        public func subDistribution(for decan:Arcana.Decan, normalized:Bool = false) -> Double {
            let level = self.level(for: decan)
            let subDistribution = normalized ? level.subDistribution/total : level.subDistribution
            return subDistribution
        }
        
        // Total Distribution
        public func totalDistribution(for decan:Arcana.Decan, normalized:Bool = false) -> Double {
            let sub = subDistribution(for: decan, normalized: normalized)
            let dist = distribution(for: decan, normalized: normalized)
            let total = sub + dist
            return total
        }
    }
}
