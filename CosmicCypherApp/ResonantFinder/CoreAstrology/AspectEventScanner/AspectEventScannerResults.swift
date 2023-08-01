//
//  AspectEventScannerResults.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/29/23.
//

import Foundation

extension AspectEventScanner {
    struct Results: Codable {
        
        var hashKey: HashKey = ""
        var data: [String: Any] = [:]

        // Custom CodingKeys enum to handle the 'data' property
        private enum CodingKeys: String, CodingKey {
            case data
        }

        // MARK: inits
        init(data: [String: Any], hashKey:HashKey) {
            self.hashKey = hashKey
            self.data = data
        }
        
        init(lockedInAspects: [Date: [CoreAstrology.Aspect]], hashKey:HashKey) {
            self.hashKey = hashKey
            self.data = convert(lockedInAspects: lockedInAspects)
        }
        
        // MARK: conversions for raw data from scanner
        func convert(lockedInAspects: [Date: [CoreAstrology.Aspect]], mode:DateConversionMode = .dateWithSubTime) -> [String: Any] {
            
            // JSON compatible data format
            var data: [String:Any] = [:]
            
            switch mode {
            case .dateOnly:
                
                // Format: [DateKey:[AspectHashes]]
                for (date, aspects) in lockedInAspects {
                    
                    // Convert Date to String for Key
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString:String = dateFormatter.string(from: date)
                    
                    // Aspects as [String] for Value
                    let aspectHashes:[String] = aspects.map( { $0.symbolHash } )
                    
                    // Add More
                    data[dateString] = aspectHashes
                }
                
            case .dateAndTime:
                
                // Format: [DateTimeKey:[AspectHashes]]
                for (date, aspects) in lockedInAspects {
                    
                    // Convert Date to String for Key
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let dateString:String = dateFormatter.string(from: date)
                    
                    // Aspects as [String] for Value
                    let aspectHashes = aspects.map( { $0.symbolHash } )
                    
                    // Add More
                    data[dateString] = aspectHashes
                }
                
            case .dateWithSubTime:
                
                // Format: [DateKey:[TimeKey:[AspectHashes]]]
                for (date, aspects) in lockedInAspects {
                    
                    // Convert Date to String for Date Key
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString:String = dateFormatter.string(from: date)
                    
                    // Convert Date to String for Time Key
                    dateFormatter.dateFormat = "'T'HH:mm:ssZ"
                    let timeString:String = dateFormatter.string(from: date)
                    
                    // Aspects as [String] for Value
                    let aspectHashes = aspects.map( { $0.symbolHash } )
                    
                    if var dateData = data[dateString] as? [String:Any] {
                        // Add More
                        dateData[timeString] = aspectHashes
                        data[dateString] = dateData
                    } else {
                        // Create New
                        data[dateString] = [timeString:aspectHashes]
                    }
                }
            }
            
            return data
        }

        // MARK: Codable
        // Encode the 'data' property
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            // Convert [String: Any] to [String: CodableValue]
            var codableData = [String: CodableValue]()
            for (key, value) in data {
                if let codableValue = CodableValue(value: value) {
                    codableData[key] = codableValue
                }
            }

            try container.encode(codableData, forKey: .data)
        }

        // Decode the 'data' property
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // Decode [String: CodableValue] to [String: Any]
            let codableData = try container.decode([String: CodableValue].self, forKey: .data)
            var decodedData = [String: Any]()
            for (key, value) in codableData {
                decodedData[key] = value.value
            }

            self.data = decodedData
        }
        
        // MARK: Fomatter
        func format(_ exportMode:AspectEventExporter.ExportMode = .json) -> String {
            return Formatter.format(results: self, exportMode: exportMode)
        }
    }

    // MARK: Helper CodableValue enum to cover all possible types in the 'data' dictionary
    enum CodableValue: Codable {
        case string(String)
        case int(Int)
        case double(Double)
        // Add more cases as needed for other types

        // Add a computed property to get the actual value from the enum
        var value: Any {
            switch self {
            case .string(let value): return value
            case .int(let value): return value
            case .double(let value): return value
            }
        }

        // Initialize the enum with an 'Any' value
        init?(value: Any) {
            if let stringValue = value as? String {
                self = .string(stringValue)
            } else if let intValue = value as? Int {
                self = .int(intValue)
            } else if let doubleValue = value as? Double {
                self = .double(doubleValue)
            } else {
                // Add more cases as needed for other types
                return nil // Return nil for unsupported types
            }
        }

        // Encode the value based on the enum case
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let value):
                try container.encode(value)
            case .int(let value):
                try container.encode(value)
            case .double(let value):
                try container.encode(value)
            }
        }

        // Decode the value based on the data type
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            } else if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
            } else if let doubleValue = try? container.decode(Double.self) {
                self = .double(doubleValue)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported data type")
            }
        }
    }
    
    enum DateConversionMode {
        case dateOnly
        case dateAndTime
        case dateWithSubTime
    }
}

// MARK: AspectEventScanner HashKey and LocationEvent
extension AspectEventScanner.Results {
    typealias HashKey = String
    struct LocationEvent {
        let startDate: Date
        let endDate: Date
        let longitude: Double
        let latitude: Double
        
        init?(hashKey: String) {
            let components = hashKey.components(separatedBy: "S")
            guard components.count == 2 else {
                return nil
            }
            
            let timeStampEndComponents = components[1].components(separatedBy: "E")
            guard timeStampEndComponents.count == 2 else {
                return nil
            }
            
            let timeStampStartString = components[0]
            let timeStampEndString = timeStampEndComponents[0]
            
            let longitudeComponents = timeStampEndComponents[1].components(separatedBy: "L")
            guard longitudeComponents.count == 2, let latitudeString = longitudeComponents.last else {
                return nil
            }
            
            guard let timeStampStart = TimeInterval(timeStampStartString),
                  let timeStampEnd = TimeInterval(timeStampEndString),
                  let longitude = Double(longitudeComponents.first ?? ""),
                  let latitude = Double(latitudeString) else {
                return nil
            }
            
            self.startDate = Date(timeIntervalSince1970: timeStampStart)
            self.endDate = Date(timeIntervalSince1970: timeStampEnd)
            self.longitude = longitude
            self.latitude = latitude
        }
        
        var hashKey:HashKey {
            return HashKey(self)
        }
    }
}

extension AspectEventScanner.Results.HashKey {
    init(_ locationEvent: AspectEventScanner.Results.LocationEvent) {
        let timeStampStart = locationEvent.startDate.timeIntervalSince1970
        let timeStampEnd = locationEvent.endDate.timeIntervalSince1970
        self = "S\(timeStampStart)E\(timeStampEnd)L\(locationEvent.longitude)L\(locationEvent.latitude)"
    }
    
    init(startDate:Date, endDate:Date, longitude:Double, latitude:Double) {
        let timeStampStart = startDate.timeIntervalSince1970
        let timeStampEnd = startDate.timeIntervalSince1970
        self = "S\(timeStampStart)E\(timeStampEnd)L\(longitude)L\(latitude)"
    }
    
}
