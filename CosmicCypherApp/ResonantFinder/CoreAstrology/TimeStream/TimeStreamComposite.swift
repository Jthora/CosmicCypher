//
//  TimeStreamComposite.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/2/22.
//

import Foundation
import SwiftAA

extension TimeStream {
    public final class Composite {
        
        let name: String?
        @objc let uuid: TimeStreamCompositeUUID
        
        var imageMap: ImageMap? = nil
        var spectrogram: TimeStreamSpectrogram? = nil
        let configuration: TimeStream.Configuration
        
        var startDate: Date? { return configuration.startDate }
        var endDate: Date? { return configuration.endDate }
        
        var resonanceScores:[StarChart.ResonanceScore] { return configuration.resonanceScores }
        
        // MARK: Init
        // Main Init
        public init(name: String? = nil, uuid:UUID? = nil, configuration: TimeStream.Configuration, imageMap: ImageMap? = nil, spectrogramView: TimeStreamSpectrogramView? = nil, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            print("❇️ New TimeStream Composite")
            
            // Assign Name
            self.name = name
            
            // Assign UUID
            if let uuid = uuid {
                self.uuid = uuid
            } else {
                self.uuid = UUID()
            }
            
            // Assign Configuration
            self.configuration = configuration
            
            // Assign ImageMap
            if let imageMap = imageMap {
                // Set ImageMap
                self.imageMap = imageMap
                onComplete?(self)
            } else {
                // Create ImageMap
                if let spectrogramView = spectrogramView,
                    let timeStream = self.configuration.timeStreams.first,
                    let metalView = spectrogramView.metalView {
                    print("existing timeStream available: \(timeStream.id)")
                    let selectedNodeTypes = StarChart.Core.selectedNodeTypes
                    let spectrogram = TimeStreamSpectrogram(metalView: metalView)
                } else {
                    Task {
                        ImageMap.create(uuid: self.uuid, configuration: self.configuration, onComplete: { imageMap in
                            self.imageMap = imageMap
                            onComplete?(self)
                        }, onProgress: { completion in
                            onProgress?(completion)
                        })
                    }
                }
            }
        }
        
        // Personal Life Path Init
        /// TimeStream of Personal Life focused onto over a Path
        public init(name: String, uuid:UUID? = nil, primaryChart: StarChart?, secondaryChart: StarChart?, timestreams: [TimeStream], nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            print("❇️ New TimeStream Composite")
            
            // Assign Name
            self.name = name
            
            // Assign UUID
            if let uuid = uuid {
                self.uuid = uuid
            } else {
                self.uuid = UUID()
            }
            
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, secondaryChart: secondaryChart, timeStreams: timestreams, nodeTypes: nodeTypes)
            
            // Assign ImageMap
            if let imageMap = imageMap {
                // Set ImageMap
                self.imageMap = imageMap
                onComplete?(self)
            } else {
                // Create ImageMap
                Task {
                    ImageMap.create(uuid: self.uuid, configuration: self.configuration, onComplete: { imageMap in
                        self.imageMap = imageMap
                        onComplete?(self)
                    }, onProgress: onProgress)
                }
            }
        }
        
        // Personal Life Path Init (alt)
        /// TimeStream of Personal Life focused onto over a Path
        public init(name: String, birthDate:Date, birthCoordinates: GeographicCoordinates, timeStreamPath:TimeStream.Path, nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) throws {
            print("❇️ New TimeStream Composite")
            let primaryChart = StarChart(date: birthDate, coordinates: birthCoordinates)
            let timeStreams:[TimeStream] = [try TimeStream(path: timeStreamPath)]
            
            // Assign Name and UUID
            self.name = name
            self.uuid = UUID()
            
            // Assign Configuration
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, timeStreams: timeStreams, nodeTypes: nodeTypes)
            
            // Assign ImageMap
            if let imageMap = imageMap {
                // Set ImageMap
                self.imageMap = imageMap
                onComplete?(self)
            } else {
                // Create ImageMap
                Task {
                    ImageMap.create(uuid: self.uuid, configuration: self.configuration, onComplete: { imageMap in
                        self.imageMap = imageMap
                        onComplete?(self)
                    }, onProgress: onProgress)
                }
            }
        }
        
        // Personal Life By Date Range Init
        /// TimeStream of Personal Life focused onto Start and End Date
        public init(name: String, birthDate:Date, birthCoordinates: GeographicCoordinates, currentCoordinates:GeographicCoordinates, startDate: Date, endDate: Date, nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            print("❇️ New TimeStream Composite")
            
            // Assign Name and UUID
            self.name = name
            self.uuid = UUID()
            
            // Setup Timestreams
            let primaryChart = StarChart(date: birthDate, coordinates: birthCoordinates)
            let timeStreams:[TimeStream] = [TimeStream(startDate: startDate, endDate: endDate, coordinates: currentCoordinates)]
            
            // Create Configuration
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, timeStreams: timeStreams, nodeTypes: nodeTypes)
            
            // Assign ImageMap
            if let imageMap = imageMap {
                // Set ImageMap
                self.imageMap = imageMap
                onComplete?(self)
            } else {
                // Create ImageMap
                Task {
                    ImageMap.create(uuid: self.uuid, configuration: self.configuration, onComplete: { imageMap in
                        self.imageMap = imageMap
                        onComplete?(self)
                    }, onProgress: onProgress)
                }
            }
        }
        
        // Personal Life for Current Date
        /// TimeStream of Personal Life until Current Date
        public init(name: String, birthDate:Date, birthCoordinates: GeographicCoordinates, currentCoordinates:GeographicCoordinates, currentDate: Date, nodeTypes: [CoreAstrology.AspectBody.NodeType], sampleCount:Int, onComplete:((Composite)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            print("❇️ New TimeStream Composite")
            
            // Assign Name and UUID
            self.name = name
            self.uuid = UUID()
            
            // Create Timestreams
            let primaryChart = StarChart(date: birthDate, coordinates: birthCoordinates)
            let timeStreams:[TimeStream] = [TimeStream(startDate: birthDate, endDate: currentDate, coordinates: currentCoordinates)]
            
            // Assign Configuration
            self.configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: primaryChart, timeStreams: timeStreams, nodeTypes: nodeTypes)
            
            // Assign ImageMap
            if let imageMap = imageMap {
                // Set ImageMap
                self.imageMap = imageMap
                onComplete?(self)
            } else {
                // Create ImageMap
                Task {
                    ImageMap.create(uuid: self.uuid, configuration: self.configuration, onComplete: { imageMap in
                        self.imageMap = imageMap
                        onComplete?(self)
                    }, onProgress: onProgress)
                }
            }
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
        
        // React Start
        TimeStream.Core.react(to: .onLoadTimeStream(loadTimeStreamAction: .start(uuid: uuid, name: name, configuration: configuration)))
        
        // Init
        self.init(name: name,
                  uuid: uuid,
                  configuration: configuration) { composite in
            // React Complete
            TimeStream.Core.react(to: .onLoadTimeStream(loadTimeStreamAction: .complete(uuid: uuid, composite: composite)))
        } onProgress: { completion in
            // React Progress
            TimeStream.Core.react(to: .onLoadTimeStream(loadTimeStreamAction: .progress(uuid: uuid, completion: completion)))
        }

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

