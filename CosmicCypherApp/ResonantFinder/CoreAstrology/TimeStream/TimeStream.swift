//
//  TimeStream.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/8/21.
//

import Foundation
import SwiftAA
import SwiftUI

/// TimeStream
///
/// follows the path of one instance travelling across the surface of earth over time

public final class TimeStream {
    
    let title:String? = nil
    let id:UUID
    
    let path:Path
    var colorRenderMode:ColorRenderMode = .colorGradient
    var dataMetric:DataMetric = .harmonics
    
    let dateRange:Range<Date>
    var starCharts:[StarChart] = []
    
    // TODO: Confirm order of Points is correct...
    init(uuid:UUID = UUID(), title:String? = nil, path:Path, dateRange:Range<Date>? = nil) throws {
        print("TimeStream:: init with path")
        id = uuid
        if let dateRange = dateRange {
            self.dateRange = dateRange
        } else {
            let sortedPoints = path.points.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
            guard let startDate = sortedPoints.first?.date,
                  let endDate = sortedPoints.last?.date else {
                      throw TimeStreamPathParseError.runtimeError("couldn't get dates from TimeStream.Path.Point")
                  }
            self.dateRange = Range<Date>(uncheckedBounds: (lower: startDate, upper: endDate))
        }
        self.path = path
    }
    
    init(uuid:UUID = UUID(), title:String? = nil, startDate:Date, endDate:Date, coordinates:GeographicCoordinates) {
        id = uuid
        dateRange = Range<Date>(uncheckedBounds: (lower: startDate, upper: endDate))
        path = Path(startDate: startDate, endDate: endDate, coordinates: coordinates)
    }
    
    init(uuid:UUID = UUID(), title:String? = nil, startDate:Date, endDate:Date, startCoordinates:GeographicCoordinates, endCoordinates:GeographicCoordinates) {
        id = uuid
        dateRange = Range<Date>(uncheckedBounds: (lower: startDate, upper: endDate))
        path = Path(startDate: startDate, endDate: endDate, startCoordinates: startCoordinates, endCoordinates: endCoordinates)
    }
    
    func loadStarCharts(sampleCount:Int? = nil, onComplete:(()->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
        print("TimeStream: load StarCharts")
        // TODO: Point Between Points - SAMPLES
        let points:[TimeStream.Point]
        if let sampleCount = sampleCount {
            points = path.subPoints(sampleCount: sampleCount)
        } else {
            points = path.points
        }
            
        let timestamp = Date()
        let count = points.count
        
        onProgress?(0)
        for (i,point) in points.enumerated() {
            onProgress?(Double(i)/Double(count))
            print("loading starchart (\(i)/\(count)) [\(timestamp.timeIntervalSinceNow)]")
            let starChart:StarChart = StarChartRegistry.main.getStarChart(date: point.date, geographicCoordinates: point.coordinates)
            append(starChart: starChart)
        }
        onProgress?(1)
        onComplete?()
    }
    
    func append(starChart:StarChart) {
        starCharts.append(starChart)
    }
    
    func astrologicalNodeStateTimeline(nodeTypes: [CoreAstrology.AspectBody.NodeType] = DEFAULT_SELECTED_NODETYPES) -> AstrologicalNodeStateTimeline {
        return AstrologicalNodeStateTimeline(starCharts, nodeTypes: nodeTypes)
    }
//
//    func planetStateTimeline(nodeTypes: [CoreAstrology.AspectBody.NodeType] = DEFAULT_SELECTED_NODETYPES) -> PlanetStateTimeline {
//        return PlanetStateTimeline.from(starCharts, nodeTypes: nodeTypes)
//    }
    
    func generateImageStrips(nodeTypes:[CoreAstrology.AspectBody.NodeType] = DEFAULT_SELECTED_NODETYPES) -> TimeStreamImageStripSet {
        return TimeStream.ImageGenerator.generateStrips(timestream: self, nodeTypes: nodeTypes)
    }
    
    
    func resonanceScores() -> [StarChart.ResonanceScore] {
        return self.starCharts.map({ $0.resonanceScore() })
    }
}


extension TimeStream: Codable {
    
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) throws -> TimeStream { return try JSONDecoder().decode(TimeStream.self, from: rawData) }
    
    enum CodingKeys: CodingKey {
        case dateRange
        case path
        case colorRenderMode
    }
    
    nonisolated public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateRange, forKey: .dateRange)
        try container.encode(path, forKey: .path)
        try container.encode(colorRenderMode.rawValue, forKey: .colorRenderMode)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding TimeStream")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let path:TimeStream.Path = try container.decode(TimeStream.Path.self, forKey: .path)
        
        try self.init(path: path)
    }
    
}

//extension TimeStream: Hashable {
//    
//    public nonisolated var hashKey: String { return String(hashValue) }
//    
//    public static func == (lhs: TimeStream, rhs: TimeStream) -> Bool {
//        return lhs.dateRange == rhs.dateRange
//    }
//    nonisolated public func hash(into hasher: inout Hasher) {
//        hasher.combine(dateRange)
//        hasher.combine(path)
//    }
//}



enum TimeStreamPathParseError: Error {
    case runtimeError(String)
}
