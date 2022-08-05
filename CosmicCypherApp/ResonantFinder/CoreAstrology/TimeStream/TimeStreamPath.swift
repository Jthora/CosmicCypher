//
//  TimeStreamPath.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/6/22.
//

import Foundation
import SwiftAA

public extension TimeStream {
    struct Point {
        var date:Date
        var coordinates:GeographicCoordinates
    }
    
    struct Path {
        var points:[Point] = []
        
        public init(points: [Point]) {
            self.points = points
        }
        
        public init(startDate: Date, endDate: Date, startCoordinates: GeographicCoordinates, endCoordinates: GeographicCoordinates) {
            points.append(Point(date: startDate, coordinates: startCoordinates))
            points.append(Point(date: endDate, coordinates: endCoordinates))
        }
        
        public init(startDate: Date, endDate: Date, coordinates: GeographicCoordinates) {
            self.init(startDate: startDate, endDate: endDate, startCoordinates: coordinates, endCoordinates: coordinates)
        }
        
        public init(date: Date, startCoordinates: GeographicCoordinates, endCoordinates: GeographicCoordinates) {
            self.init(startDate: date, endDate: date, startCoordinates: startCoordinates, endCoordinates: endCoordinates)
        }
        
        func starChartHashes() -> [StarChartHashKey] {
            return points.map { point in
                return StarChartHashKey(point: point)
            }
        }
        
        func subPoints(sampleCount:Int) -> [Point] {
            var subPoints:[Point] = []
            for index in 0...sampleCount {
                guard let subPoint = subPoint(index: index, sampleCount: sampleCount) else {
                    continue
                }
                subPoints.append(subPoint)
            }
            return subPoints
        }
        
        func subPoint(index:Int, sampleCount:Int) -> Point? {
            guard index < sampleCount else {
                return nil
            }
            let sortedPoints = self.points.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
            guard let startDate = sortedPoints.first?.date,
                  let endDate = sortedPoints.last?.date,
                  let startCoordinates = sortedPoints.first?.coordinates,
                  let endCoordinates = sortedPoints.last?.coordinates else {
                      return nil
                  }
            
            let timeInterval: TimeInterval = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
            let timeStep: TimeInterval = timeInterval / TimeInterval(sampleCount)
            let timeDiff: TimeInterval = timeStep * TimeInterval(index)
            
            let date = startDate.addingTimeInterval(timeDiff)
            
            let latitudeInterval = startCoordinates.latitude - endCoordinates.latitude
            let latitudeStep = latitudeInterval / Degree(integerLiteral: sampleCount)
            let latitudeDiff = latitudeStep * Degree(integerLiteral: index)
            
            let latitude = startCoordinates.latitude + latitudeDiff
            
            let longitudeInterval = startCoordinates.latitude - endCoordinates.latitude
            let longitudeStep = longitudeInterval / Degree(integerLiteral: sampleCount)
            let longitudeDiff = longitudeStep * Degree(integerLiteral: index)
            
            let longitude = startCoordinates.latitude + longitudeDiff
            
            let altitudeInterval = startCoordinates.altitude - endCoordinates.altitude
            let altitudeStep = altitudeInterval / Meter(integerLiteral: sampleCount)
            let altitudeDiff = altitudeStep * Meter(integerLiteral: index)
            
            let altitude = startCoordinates.altitude + altitudeDiff
            
            let coordinates = GeographicCoordinates(positivelyWestwardLongitude: longitude, latitude: latitude, altitude: altitude)
            
            return Point(date: date, coordinates: coordinates)
        }
        
        func starChart(for subPoint:Point) -> StarChart {
            return StarChartRegistry.main.getStarChart(date: subPoint.date, geographicCoordinates: subPoint.coordinates)
        }
    }
}

extension TimeStream.Point: Codable {
    
    public func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public static func from(rawData: Data) throws -> TimeStream.Point { return try JSONDecoder().decode(TimeStream.Point.self, from: rawData) }
    
    enum CodingKeys: CodingKey {
        case date
        case coordinates
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(coordinates, forKey: .coordinates)
    }
    
    public init(from decoder: Decoder) throws {
        //print("decoding Point")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(Date.self, forKey: .date)
        let coordinates = try container.decode(GeographicCoordinates.self, forKey: .coordinates)
        self = TimeStream.Point(date: date, coordinates: coordinates)
    }
}

extension TimeStream.Path: Codable {
    
    public func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public static func from(rawData: Data) throws -> TimeStream.Path { return try JSONDecoder().decode(TimeStream.Path.self, from: rawData) }
    
    enum CodingKeys: CodingKey {
        case points
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }
    
    public init(from decoder: Decoder) throws {
        //print("decoding Path")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let points = try container.decode([TimeStream.Point].self, forKey: .points)
        self = TimeStream.Path(points: points)
    }
}

extension Hashable {
    public var hashKey: String { return String(hashValue) }
}

//extension TimeStream.Point: Hashable {
//
//
//
//    public static func == (lhs: TimeStream.Point, rhs: TimeStream.Point) -> Bool {
//        return lhs.date == rhs.date && lhs.coordinates == rhs.coordinates
//    }
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(date)
//        hasher.combine(coordinates)
//    }
//
//
//}

//extension TimeStream.Path: Hashable {
//
//    public var hashKey: String { return String(hashValue) }
//
//    public static func == (lhs: TimeStream.Path, rhs: TimeStream.Path) -> Bool {
//        return lhs.points == rhs.points
//    }
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(points)
//    }
//}
