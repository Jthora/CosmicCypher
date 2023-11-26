//
//  TimeStreamConfiguration.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/12/22.
//

import Foundation

// TimeStream Configuration
/// used for defining which planets to graphically generate for
extension TimeStream {
    public final class Configuration {
        
        var sampleCount:Int
        
        var primaryChart: StarChart? = nil
        var secondaryChart: StarChart? = nil
        
        var nodeTypes: [CoreAstrology.AspectBody.NodeType] = []
        var timeStreams: [TimeStream] = []
        
        var startDate: Date? {
            return timeStreams.first?.dateRange.lowerBound
        }
        var endDate: Date? {
            return timeStreams.last?.dateRange.upperBound
        }
        
        init(sampleCount: Int, primaryChart: StarChart? = nil, secondaryChart: StarChart? = nil, timeStreams: [TimeStream] = [], nodeTypes: [CoreAstrology.AspectBody.NodeType] = []) {
            self.sampleCount = sampleCount
            self.primaryChart = primaryChart
            self.secondaryChart = secondaryChart
            self.timeStreams = timeStreams
            self.nodeTypes = nodeTypes
        }
        
        var resonanceScores: [StarChart.ResonanceScore] {
            return timeStreams.first?.resonanceScores() ?? []
        }
    }
}

extension TimeStream.Configuration: Codable {}

