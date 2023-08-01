//
//  AspectEventScannerResultsFormatter.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/30/23.
//

import Foundation

extension AspectEventScanner.Results {
    struct Formatter {
        
        // MARK: Format
        static func format(results: AspectEventScanner.Results, exportMode: AspectEventExporter.ExportMode) -> String {
            switch exportMode {
            case.json: return formatJSON(results: results)
            case.txt: return formatTXT(data: results.data)
            case.symbols: return formatSymbols(data: results.data)
            case.emoji: return formatEmoji(data: results.data)
            }
        }
        
        // MARK: Formatters
        static func formatJSON(results: AspectEventScanner.Results) -> String {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                // Convert [String: Any] to [String: AnyEncodable]
                let encodableData = try results.data.mapValues { value -> AnyEncodable in
                    guard let encodableValue = value as? Encodable else {
                        throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Value is not encodable."))
                    }
                    return AnyEncodable(encodableValue)
                }
                
                // Encode the encodable dictionary
                let jsonData = try encoder.encode(encodableData)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            } catch {
                print("Encoding error: \(error)")
            }
            return ""
        }
        
        static func formatTXT(data: [String:Any], indentationLevel: Int = 0) -> String {
            var formattedString = ""
            let indentation = String(repeating: "    ", count: indentationLevel)

            for (key, value) in data {
                formattedString += "\(indentation)\(key): "

                if let nestedData = value as? [String: Any] {
                    // If the value is another dictionary, recursively format it
                    formattedString += "\n\(formatTXT(data: nestedData, indentationLevel: indentationLevel + 1))"
                } else {
                    // Otherwise, simply append the value
                    formattedString += "\(value)\n"
                }
            }

            return formattedString
        }
        
        static func formatSymbols(data: [String:Any], indentationLevel: Int = 0) -> String {
            var formattedString = ""
            let indentation = String(repeating: "    ", count: indentationLevel)

            for (key, value) in data {
                formattedString += "\(indentation)\(key): "

                if let nestedData = value as? [String: Any] {
                    // If the value is another dictionary, recursively format it
                    formattedString += "\n\(formatTXT(data: nestedData, indentationLevel: indentationLevel + 1))"
                } else {
                    // Otherwise, simply append the value
                    let string = txtToSymbol(string: "\(value)")
                    formattedString += "\(string)\n"
                }
            }

            return formattedString
        }
        
        static func formatEmoji(data: [String:Any], indentationLevel: Int = 0) -> String {
            var formattedString = ""
            let indentation = String(repeating: "    ", count: indentationLevel)

            for (key, value) in data {
                formattedString += "\(indentation)\(key): "

                if let nestedData = value as? [String: Any] {
                    // If the value is another dictionary, recursively format it
                    formattedString += "\n\(formatTXT(data: nestedData, indentationLevel: indentationLevel + 1))"
                } else {
                    // Otherwise, simply append the value
                    let string1 = txtToEmoji(string: "\(value)")
                    let string2 = txtToSymbol(string: "\(string1)")
                    formattedString += "\(string2)\n"
                }
            }

            return formattedString
        }
        
        // MARK: String Converters
        static func txtToSymbol(string:String) -> String {
            switch string {
                // Planets
            case "sun": return "☉"
            case "mercury": return "☿"
            case "venus": return "♀"
            case "earth": return "♁"
            case "mars": return "♂"
            case "jupiter": return "♃"
            case "saturn": return "♄"
            case "uranus": return "♅"
            case "neptune": return "♆"
            case "pluto": return "♇"
                // Primary Aspects
            case "conjunction": return "☌" // 0°
            case "opposition": return "☍" // 180°
            case "trine": return "△" // 120°
            case "square": return "☐" // 90°
            case "sextile": return "⚹" // 60°
            case "quincunx": return "⚻" // 150°
                // Secondary Aspects
            case "semi-sextile": return "⚺" // 30°
            case "semi-square": return "∠" // 45°
            case "sesquiquadrate": return "⚼" // 135°
            case "quintile": return "⭐︎" // 72°
            case "bi-quintile": return "⭐︎²" // 144°
                // Tertiary Aspects
            case "septile": return "7¹" // 51.4285714286°
            case "bi-septile": return "7²" // 102.8571428571°
            case "tri-septile": return "7³" // 154.2857142857°
            case "novile": return "9¹" // 40°
            case "bi-novile": return "9²" // 80°
            case "quad-novile": return "9⁴" // 160°
            case "decile": return "10¹" // 36°
                // Lat Long
            case "coordinates": return "⌖"
            case "date": return "date"
            case "time": return "⏲"
            case "latitude": return "↕"
            case "longitude": return "↔"
                // Zodiac
            case "aries": return "♈︎"
            case "taurus": return "♉︎"
            case "gemini": return "♊︎"
            case "cancer": return "♋︎"
            case "leo": return "♌︎"
            case "virgo": return "♍︎"
            case "libra": return "♎︎"
            case "scorpio": return "♏︎"
            case "sagittarius": return "♐︎"
            case "capricorn": return "♑︎"
            case "aquarius": return "♒︎"
            case "pisces": return "♓︎"
            default: return string
            }
        }
        
        static func txtToEmoji(string:String) -> String {
            switch string {
                // Data Metrics
            case "coordinates": return "🗺️"
            case "date": return "🗓️"
            case "time": return "⏱️"
            case "latitude": return "↕️"
            case "longitude": return "↔️"
                // Zodiac
            case "aries": return "♈️"
            case "taurus": return "♉️"
            case "gemini": return "♊️"
            case "cancer": return "♋️"
            case "leo": return "♌️"
            case "virgo": return "♍️"
            case "libra": return "♎️"
            case "scorpio": return "♏️"
            case "sagittarius": return "♐️"
            case "capricorn": return "♑️"
            case "aquarius": return "♒️"
            case "pisces": return "♓️"
            default: return string
            }
        }
    }
    
    struct AnyEncodable: Encodable {
        let value: Encodable
        
        init(_ value: Encodable) {
            self.value = value
        }
        
        func encode(to encoder: Encoder) throws {
            try value.encode(to: encoder)
        }
    }
}

