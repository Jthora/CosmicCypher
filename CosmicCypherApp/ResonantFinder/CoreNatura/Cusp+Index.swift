//
//  Cusp+Index.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/14/23.
//

import Foundation


extension Arcana.Cusp {
    
    public class Level {
        var power:Double = 0
        var unlock:Double = 0
        var distribution:Double = 0
        var subDistribution:Double = 0
    }
    
    public class Index {
        
        public var count:Double = 0
        public var powerCount:Double = 0
        
        // Cusp Levels
        public var cuspLevels:[Arcana.Cusp:Level] {
            get {
                return _base24Levels
            }
        }
        private var _base24Levels:[Arcana.Cusp:Level] = {
            let cusps = Arcana.Cusp.allCases
            var base24 = [Arcana.Cusp:Level]()
            for cusp in cusps {
                base24[cusp] = Level()
            }
            return base24
        }()
        func level(for cusp: Arcana.Cusp) -> Level {
            return cuspLevels[cusp]!
        }
        
        // Totals & Averages
        public var totalPower:Double {
            var total:Double = 0
            for cusp in Arcana.Cusp.allCases {
                total += self.power(for: cusp)
            }
            return total
        }
        
        public var totalUnlock:Double {
            var total:Double = 0
            for cusp in Arcana.Cusp.allCases {
                total += self.unlock(for: cusp)
            }
            return total
        }
        
        public var total:Double {
            return totalPower + totalUnlock
        }
        
        public var average:Double {
            return total / Double(Arcana.Cusp.allCases.count)
        }
        
        // Init
        public init(alignments: [CoreAstrology.AspectBody.NodeType:AstrologicalNode], limitList:[CoreAstrology.AspectBody.NodeType]? = nil , limitType:[AstrologicalNodeSubType]? = nil) {
            
            
            for (_,alignment) in alignments {
                
                if let limitList = limitList {
                    guard limitList.contains(alignment.nodeType) else { continue }
                }
                
                if let limitType = limitType {
                    guard limitType.contains(alignment.subType) else { continue }
                }
                
                let chevron = alignment.createChevron()
                // Distribution
                add(distribution: chevron.cuspDistribution, to: chevron.cusp)
                add(subDistribution: chevron.subCuspDistribution, to: chevron.subCusp)
                
                count += 1
            }
        }
        
        
        // Add
        public func add(power:Double, to cusp:Arcana.Cusp) {
            self.level(for: cusp).power += power
        }
        
        public func add(unlock:Double, to cusp:Arcana.Cusp) {
            self.level(for: cusp).unlock += unlock
        }
        
        public func add(distribution:Double, to cusp:Arcana.Cusp) {
            self.level(for: cusp).distribution += distribution
        }
        
        public func add(subDistribution:Double, to cusp:Arcana.Cusp) {
            self.level(for: cusp).subDistribution += subDistribution
        }
        
        // Get
        public func power(for cusp:Arcana.Cusp, normalized:Bool = false) -> Double {
            let level = self.level(for: cusp)
            let power = normalized ? level.power/total : level.power
            return power
        }
        
        public func unlock(for cusp:Arcana.Cusp, normalized:Bool = false) -> Double {
            let level = self.level(for: cusp)
            let unlock = normalized ? level.unlock/total : level.unlock
            return unlock
        }
        
        public func distribution(for cusp:Arcana.Cusp, normalized:Bool = false) -> Double {
            let level = self.level(for: cusp)
            let distribution = normalized ? level.distribution/total : level.distribution
            return distribution
        }
        
        public func subDistribution(for cusp:Arcana.Cusp, normalized:Bool = false) -> Double {
            let level = self.level(for: cusp)
            let subDistribution = normalized ? level.subDistribution/total : level.subDistribution
            return subDistribution
        }
        
        // Total Distribution
        public func totalDistribution(for cusp:Arcana.Cusp, normalized:Bool = false) -> Double {
            let sub = subDistribution(for: cusp, normalized: normalized)
            let dist = distribution(for: cusp, normalized: normalized)
            let total = sub + dist
            return total
        }
    }
}
