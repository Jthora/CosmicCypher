//
//  CoreAstrology+AspectRelation.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import SwiftAA
import Foundation

// MARK: Aspect Relation
extension CoreAstrology {
    public final class AspectRelation {
        
        public var type:AspectRelationType
        public var nodeDistance:Degree
        
        public enum AspectRelationCategory {
            case ease
            case difficulty
            case creativity
            case improbability
            case transcendance
            case divinity
            case unknown
        }
        
        public var category:AspectRelationCategory {
            switch type {
            case .conjunction, .sextile, .trine, .oneTwelfth: return .ease
            case .opposition, .square, .semisquare, .bisemisquare, .fiveTwelfth: return .difficulty
            case .quintile, .biquintile: return .creativity
            case .septile, .biseptile, .triseptile: return .improbability
            case .novile, .binovile, .quadranovile: return .transcendance
            case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return .divinity
            default: return .unknown
            }
        }
        
        public var isEase:Bool {
            switch type {
            case .conjunction, .sextile, .trine: return true
            default: return false
            }
        }
        public var isDifficult:Bool {
            switch type {
            case .opposition, .square, .semisquare, .bisemisquare: return true
            default: return false
            }
        }
        public var isMagic:Bool {
            switch type {
            case .conjunction, .sextile, .trine: return true
            default: return false
            }
        }
        
        public var orbDistance:Degree {
            return type.degree - abs(nodeDistance)
        }
        
        public var concentration:Double {
            let ratio = 1-(abs(self.orbDistance.value)/self.type.orb.value)
            return Double(ratio)
        }
        
        public init(nodeDistance:Degree, forceWith t: AspectRelationType) {
            self.nodeDistance = nodeDistance
            self.type = t
        }
        
        public init?(nodeDistance:Degree, limitTypes:[AspectRelationType] = AspectRelationType.allCases) {
            self.nodeDistance = nodeDistance
            guard let t = AspectRelationType(nodeDistance: nodeDistance, limitTypes: limitTypes) else {return nil}
            self.type = t
        }
        
        public var defaultDescription:String {
            return type.defaultDescription
        }
    }
}
