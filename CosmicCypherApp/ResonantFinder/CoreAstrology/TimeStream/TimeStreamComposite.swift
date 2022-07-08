//
//  TimeStreamComposite.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/2/22.
//

import Foundation
import SwiftAA

extension TimeStream {
    public final class Composite {
        
        let name: String?
        @objc let uuid: TimeStreamCompositeUUID
        
        let imageMap: ImageMap
        let configuration: TimeStream.Configuration
        
        var startDate: Date? { return configuration.startDate }
        var endDate: Date? { return configuration.endDate }
        
        init(name: String? = nil, uuid:UUID? = nil, configuration: TimeStream.Configuration, imageMap: ImageMap? = nil, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            self.name = name
            
            if let uuid = uuid {
                self.uuid = uuid
            } else {
                self.uuid = UUID()
            }
            
            self.configuration = configuration
            
            
            if let imageMap = imageMap {
                self.imageMap = imageMap
                onComplete?(self)
            } else {
                self.imageMap = ImageMap(uuid: self.uuid, configuration: configuration, onProgress: onProgress)
                onComplete?(self)
            }
        }
        
        /// TimeStream of Personal Life focused onto over a Path
        init(name: String, uuid:UUID? = nil, primaryChart: StarChart?, secondaryChart: StarChart?, timestreams: [TimeStream], nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            self.name = name
            
            if let uuid = uuid {
                self.uuid = uuid
            } else {
                self.uuid = UUID()
            }
            
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, secondaryChart: secondaryChart, timeStreams: timestreams, nodeTypes: nodeTypes)
            self.imageMap = ImageMap(uuid: self.uuid, configuration: self.configuration, onProgress: onProgress)
            onComplete?(self)
        }
        
        /// TimeStream of Personal Life focused onto over a Path
        init(name: String, birthDate:Date, birthCoordinates: GeographicCoordinates, timeStreamPath:TimeStream.Path, nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) throws {
            let primaryChart = StarChart(date: birthDate, coordinates: birthCoordinates)
            let timeStreams:[TimeStream] = [try TimeStream(path: timeStreamPath)]
            
            self.name = name
            self.uuid = UUID()
            
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, timeStreams: timeStreams, nodeTypes: nodeTypes)
            self.imageMap = ImageMap(uuid: self.uuid, configuration: self.configuration, onProgress: onProgress)
            onComplete?(self)
        }
        
        /// TimeStream of Personal Life focused onto Start and End Date
        init(name: String, birthDate:Date, birthCoordinates: GeographicCoordinates, currentCoordinates:GeographicCoordinates, startDate: Date, endDate: Date, nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            self.name = name
            self.uuid = UUID()
            
            let primaryChart = StarChart(date: birthDate, coordinates: birthCoordinates)
            let timeStreams:[TimeStream] = [TimeStream(startDate: startDate, endDate: endDate, coordinates: currentCoordinates)]
            
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, timeStreams: timeStreams, nodeTypes: nodeTypes)
            self.imageMap = ImageMap(uuid: self.uuid, configuration: self.configuration, onProgress: onProgress)
            onComplete?(self)
        }
        
        /// TimeStream of Personal Life until Current Date
        init(name: String, birthDate:Date, birthCoordinates: GeographicCoordinates, currentCoordinates:GeographicCoordinates, currentDate: Date, nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            self.name = name
            self.uuid = UUID()
            
            let primaryChart = StarChart(date: birthDate, coordinates: birthCoordinates)
            let timeStreams:[TimeStream] = [TimeStream(startDate: birthDate, endDate: currentDate, coordinates: currentCoordinates)]
            
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, timeStreams: timeStreams, nodeTypes: nodeTypes)
            self.imageMap = ImageMap(uuid: self.uuid, configuration: self.configuration, onProgress: onProgress)
            onComplete?(self)
        }
    }
}

extension TimeStream.Composite: Codable {
    
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(rawData: Data) throws -> TimeStream.Composite { return try JSONDecoder().decode(TimeStream.Composite.self, from: rawData) }
    
    enum CodingKeys: CodingKey {
        case name
        case uuid
        case configuration
    }
    
    nonisolated public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(configuration, forKey: .configuration)
    }
    
    private static var _timestreamDecodingBuffer: [String:[TimeStream?]] = [:]
    public convenience init(from decoder: Decoder) throws {
        //print("decoding Composite")
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let configuration = try container.decode(TimeStream.Configuration.self, forKey: .configuration)
        
        self.init(name: name,
                  uuid: uuid,
                  configuration: configuration)
    }
}

extension TimeStream.Composite: Hashable {
    
    public nonisolated var hashKey: String { return String(hashValue) }
    
    public static func == (lhs: TimeStream.Composite, rhs: TimeStream.Composite) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

