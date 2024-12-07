//
//  CoreAstrology+AspectType.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import Foundation

// MARK: Aspect Type
extension CoreAstrology {
    // Aspect Type
    public struct AspectType: Equatable {
        public typealias SymbolHash = String
        
        public var primaryBodyType:AspectBody.NodeType
        public var relationType:AspectRelationType
        public var secondaryBodyType:AspectBody.NodeType
        
        public var hash:SymbolHash {
            return "\(primaryBodyType.symbol) \(relationType.symbol) \(secondaryBodyType.symbol)"
        }
        
        public func aspect(for date:Date) -> Aspect? {
            //print("creating aspect for: \(hash)")
            guard let b1 = AspectBody(type: primaryBodyType, date: date),
                  let b2 = AspectBody(type: secondaryBodyType, date: date),
                  let d = b1.longitudeDifference(from: b2, on: date),
                  let r = AspectRelation(nodeDistance: d, limitTypes: [relationType]) else { return nil }
            //print("using b1(\(b1.type.symbol)) b2(\(b2.type.symbol)) r(\(r.type.symbol))")
            let aspect = Aspect(primaryBody: b1, relation: r, secondaryBody: b2)
            //print("created aspect: \(aspect.hash)")
            return aspect
        }
    }
}
