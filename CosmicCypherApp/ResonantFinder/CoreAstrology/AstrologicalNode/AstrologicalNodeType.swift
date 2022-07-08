//
//  AstrologicalNodeType.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/4/22.
//

import Foundation

public typealias AstrologicalNodeType = CoreAstrology.AspectBody.NodeType
public enum AstrologicalNodeSubType: Int {
    case body
    case apogee // .
    case perigee // o
    case ascending // ^
    case decending // u
    case point // +
}
