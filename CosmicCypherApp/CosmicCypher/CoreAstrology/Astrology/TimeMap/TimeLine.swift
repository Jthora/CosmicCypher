//
//  TimeLine.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation

// MARK: Timeline
extension TimeStream {
    // Time Line
    public class TimeLine {
        var imageStrip:ImageStrip? = nil
        var planetNodeStates:[Date:PlanetNodeState] = [:]
    }
}
