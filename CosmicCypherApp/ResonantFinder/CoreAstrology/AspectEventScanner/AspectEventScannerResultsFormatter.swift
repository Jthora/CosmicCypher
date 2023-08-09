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
        static func format(results: AspectEventScanner.Results, exportMode: AspectEventExporter.ExportMode, formatOption:Option, includeLegend:Bool, verbose:Bool) -> String {
            switch exportMode {
            case.json: return formatJSON(results: results, formatOption:formatOption, includeLegend:includeLegend, verbose:verbose)
            case.txt: return formatTXT(data: results.data, formatOption:formatOption, includeLegend:includeLegend, verbose:verbose)
            }
        }
        
        // MARK: Formatters
        static func formatJSON(results: AspectEventScanner.Results, formatOption:Option, includeLegend:Bool, verbose:Bool) -> String {
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
        
        static func formatTXT(data: [String:Any], formatOption:Option, includeLegend:Bool, verbose:Bool, indentationLevel: Int = 0) -> String {
            var formattedString = ""
            let indentation = String(repeating: "    ", count: indentationLevel)
            
            let keys = data.keys.sorted()
            for key in keys {
                guard let value = data[key] else { continue }
                formattedString += "\(indentation)\(key): "

                if let nestedData = value as? [String: Any] {
                    // If the value is another dictionary, recursively format it
                    formattedString += "\n\(formatTXT(data: nestedData, formatOption:formatOption, includeLegend:includeLegend, verbose:verbose, indentationLevel: indentationLevel + 1))"
                } else {
                    // Otherwise, simply append the value
                    formattedString += "\(value)\n"
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
            case "date": return "D"
            case "time": return "T"
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
        
        static func symbolToTxt(symbol: String) -> String {
            switch symbol {
                // Planets
            case "☉": return "sun"
            case "☿": return "mercury"
            case "♀": return "venus"
            case "♁": return "earth"
            case "♂": return "mars"
            case "♃": return "jupiter"
            case "♄": return "saturn"
            case "♅": return "uranus"
            case "♆": return "neptune"
            case "♇": return "pluto"
                // Primary Aspects
            case "☌": return "conjunction"
            case "☍": return "opposition"
            case "△": return "trine"
            case "☐": return "square"
            case "⚹": return "sextile"
            case "⚻": return "quincunx"
                // Secondary Aspects
            case "⚺": return "semi-sextile"
            case "∠": return "semi-square"
            case "⚼": return "sesquiquadrate"
            case "⭐︎": return "quintile"
            case "⭐︎²": return "bi-quintile"
                // Tertiary Aspects
            case "7¹": return "septile"
            case "7²": return "bi-septile"
            case "7³": return "tri-septile"
            case "9¹": return "novile"
            case "9²": return "bi-novile"
            case "9⁴": return "quad-novile"
            case "10¹": return "decile"
                // Lat Long
            case "⌖": return "coordinates"
            case "D": return "date"
            case "T": return "time"
            case "↕": return "latitude"
            case "↔": return "longitude"
                // Zodiac
            case "♈︎": return "aries"
            case "♉︎": return "taurus"
            case "♊︎": return "gemini"
            case "♋︎": return "cancer"
            case "♌︎": return "leo"
            case "♍︎": return "virgo"
            case "♎︎": return "libra"
            case "♏︎": return "scorpio"
            case "♐︎": return "sagittarius"
            case "♑︎": return "capricorn"
            case "♒︎": return "aquarius"
            case "♓︎": return "pisces"
            default: return symbol
            }
        }
        
        static func symbolToLetters(symbol: String) -> String {
            switch symbol {
                // Planets
            case "☉": return "sun"
            case "☿": return "mer"
            case "♀": return "ven"
            case "♁": return "ear"
            case "♂": return "mar"
            case "♃": return "jup"
            case "♄": return "sat"
            case "♅": return "ura"
            case "♆": return "nep"
            case "♇": return "plu"
                // Primary Aspects
            case "☌": return "con"
            case "☍": return "opp"
            case "△": return "tri"
            case "☐": return "squ"
            case "⚹": return "sex"
            case "⚻": return "qui"
                // Secondary Aspects
            case "⚺": return "s-sex"
            case "∠": return "s-squ"
            case "⚼": return "sesqu"
            case "⭐︎": return "qui"
            case "⭐︎²": return "b-qui"
                // Tertiary Aspects
            case "7¹": return "sep"
            case "7²": return "b-sep"
            case "7³": return "t-sep"
            case "9¹": return "nov"
            case "9²": return "b-nov"
            case "9⁴": return "q-nov"
            case "10¹": return "dec"
                // Lat Long
            case "⌖": return "coords"
            case "D": return "date"
            case "T": return "time"
            case "↕": return "lat"
            case "↔": return "long"
                // Zodiac
            case "♈︎": return "ari"
            case "♉︎": return "tau"
            case "♊︎": return "gem"
            case "♋︎": return "can"
            case "♌︎": return "leo"
            case "♍︎": return "vir"
            case "♎︎": return "lib"
            case "♏︎": return "sco"
            case "♐︎": return "sag"
            case "♑︎": return "cap"
            case "♒︎": return "aqu"
            case "♓︎": return "pis"
            default: return symbol
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


extension AspectEventScanner.Results.Formatter {
    enum Option: Int {
        case symbols
        case letters
        case words
        
        var fileText:String {
            switch self {
            case .words: return "words"
            case .letters: return "letters"
            case .symbols: return "symbols"
            }
        }
    }
}
