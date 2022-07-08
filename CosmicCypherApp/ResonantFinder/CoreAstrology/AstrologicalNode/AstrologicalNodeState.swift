//
//  AstrologicalNodeState.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/4/22.
//

import Foundation

public class AstrologicalNodeState {
    
    var nodeType:AstrologicalNodeType
    var subType:AstrologicalNodeSubType
    var date:Date
    var degrees:Double
    
    init(nodeType:AstrologicalNodeType, subType:AstrologicalNodeSubType, date:Date, degrees:Double) {
        self.nodeType = nodeType
        self.subType = subType
        self.date = date
        self.degrees = degrees
    }
    
    public func codable() -> CodableAstrologicalNodeState {
        return CodableAstrologicalNodeState(nodeType: nodeType,
                                            subType: subType,
                                            date: date,
                                            degrees: degrees)
    }
    
    public var hash: Int {
        return AstrologicalNodeStateHash(date: date, nodeType: nodeType, subType: subType)
    }
    
}

public final class CodableAstrologicalNodeState: AstrologicalNodeState, Codable {
    
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) throws -> AstrologicalNodeState { return try JSONDecoder().decode(CodableAstrologicalNodeState.self, from: rawData).convert() }
    
    enum CodingKeys: CodingKey {
        case nodeType
        case subType
        case date
        case degrees
    }
    
    nonisolated public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(nodeType.rawValue, forKey: .nodeType)
        try container.encode(subType.rawValue, forKey: .subType)
        try container.encode(date, forKey: .date)
        try container.encode(degrees, forKey: .degrees)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding PlanetState")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nodeType:Int = try container.decode(Int.self, forKey: .nodeType)
        let subType:Int = try container.decode(Int.self, forKey: .subType)
        let date:Date = try container.decode(Date.self, forKey: .date)
        let degrees:Double = try container.decode(Double.self, forKey: .degrees)
        
        self.init(nodeType: AstrologicalNodeType(rawValue: nodeType)!,
                  subType: AstrologicalNodeSubType(rawValue: subType)!,
                  date: date,
                  degrees: degrees)
    }
    
    public func convert() -> AstrologicalNodeState {
        return AstrologicalNodeState(nodeType: nodeType,
                                     subType: subType,
                                     date: date,
                                     degrees: degrees)
    }
}
