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
                var data = results.data
                if includeLegend { data["legend"] = verbose ? verboseLegendDictionary : legendDictionary }
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    var string = jsonString
                    
                    switch formatOption {
                    case .symbols: ()
                    case .letters:
                        for symbol in symbolArray {
                            switch symbol {
                            case "T": continue;
                            default: ()
                            }
                            string = string.replacingOccurrences(of: symbol, with: symbolToLetters(symbol: symbol))
                        }
                    case .words:
                        for symbol in symbolArray {
                            switch symbol {
                            case "T": continue;
                            default: ()
                            }
                            string = string.replacingOccurrences(of: symbol, with: symbolToWords(symbol: symbol))
                        }
                    }
                    
                    return string
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
                guard let rawValue = data[key] else { continue }
                
                var formattedKey: String = key
                
                // Format Legend and Date
                if indentationLevel == 0 {
                    if includeLegend { formattedString = verbose ? verboseTxtLegend : txtLegend }
                    
                    if verbose {
                        switch formatOption {
                        case .letters, .words: formattedString += "date "
                        case .symbols: formattedString += "D"
                        }
                    }
                } else {
                    // Format Time for Verbose
                    if verbose {
                        formattedKey
                        // Format Time for Key
                        switch formatOption {
                        case .letters, .words:
                            formattedKey = formattedKey.replacingOccurrences(of: "T", with: "time ")
                        default: ()
                        }
                    } else {
                        formattedKey = formattedKey.replacingOccurrences(of: "T", with: "")
                        let regex = try! NSRegularExpression(pattern: "-[0-9]+", options: .caseInsensitive)
                        let range = NSMakeRange(0, formattedKey.count)
                        formattedKey = regex.stringByReplacingMatches(in: formattedKey, options: [], range: range, withTemplate: "")

                    }
                }
                
                // Add Key
                formattedString += "\(indentation)\(formattedKey): "
                
                if let nestedData = rawValue as? [String: Any] {
                    // If the value is another dictionary, recursively format it
                    formattedString += "\n\(formatTXT(data: nestedData, formatOption:formatOption, includeLegend:includeLegend, verbose:verbose, indentationLevel: indentationLevel + 1))"
                } else {
                    var value: String = "\(rawValue)"
                    
                    // Convert String for Format Option
                    switch formatOption {
                    case .symbols: ()
                    case .letters:
                        for symbol in symbolArray {
                            value = value.replacingOccurrences(of: symbol, with: symbolToLetters(symbol: symbol))
                        }
                    case .words:
                        for symbol in symbolArray {
                            value = value.replacingOccurrences(of: symbol, with: symbolToWords(symbol: symbol))
                        }
                    }
                    
                    if value.contains("♂") || value.contains("⚹"){
                        print("value: \(value)")
                    }
                    
                    // Otherwise, simply append the value
                    formattedString += "\(value)\n"
                }
            }

            return formattedString
        }
        
        // MARK: String Converters
        static func wordsToSymbol(string:String) -> String {
            switch string {
                // Planets
            case "sun": return "☉"
            case "moon": return "☽"
            case "mercury": return "☿"
            case "venus": return "♀"
            case "earth": return "♁"
            case "mars": return "♂"
            case "jupiter": return "♃"
            case "saturn": return "♄"
            case "uranus": return "♅"
            case "neptune": return "♆"
            case "pluto": return "♇"
                // Nodes
            case "ascendant": return "Asc"
            case "decendant": return "Dec"
            case "midheaven": return "MH"
            case "imumCoeli": return "IC"
            case "lunarAscendingNode": return "☊"
            case "lunarDecendingNode": return "☋"
            case "lunarApogee": return "⚸"
            case "lunarPerigee": return "-⚸"
            case "partOfFortune": return "Ⓧ"
            case "partOfSpirit": return "꩜"
            case "partOfEros": return "♡"
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
        
        static func symbolToWords(symbol: String) -> String {
            switch symbol {
                // Planets
            case "☉": return "sun"
            case "☽": return "moon"
            case "☿": return "mercury"
            case "♀": return "venus"
            case "♁": return "earth"
            case "♂": return "mars"
            case "♃": return "jupiter"
            case "♄": return "saturn"
            case "♅": return "uranus"
            case "♆": return "neptune"
            case "♇": return "pluto"
                // Nodes
            case "Asc": return "ascendant"
            case "Dec": return "decendant"
            case "MH": return "midheaven"
            case "IC": return "imumCoeli"
            case "☊": return "lunarAscendingNode"
            case "☋": return "lunarDecendingNode"
            case "⚸": return "lunarApogee"
            case "-⚸": return "lunarPerigee"
            case "Ⓧ": return "partOfFortune"
            case "꩜": return "partOfSpirit"
            case "♡": return "partOfEros"
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
            case "☽": return "moo"
            case "☿": return "mer"
            case "♀": return "ven"
            case "♁": return "ear"
            case "♂": return "mar"
            case "♃": return "jup"
            case "♄": return "sat"
            case "♅": return "ura"
            case "♆": return "nep"
            case "♇": return "plu"
                // Nodes
            case "Asc": return "asc"
            case "Dec": return "dec"
            case "MH": return "mh"
            case "IC": return "ic"
            case "☊": return "lnn"
            case "☋": return "lsn"
            case "⚸": return "la"
            case "-⚸": return "lp"
            case "Ⓧ": return "pof"
            case "꩜": return "pos"
            case "♡": return "poe"
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
        
        static let txtLegend: String = """
☉ (sun), sun
☽ (moo), moon
☿ (mer), mercury
♀ (ven), venus
♁ (ear), earth
♂ (mar), mars
♃ (jup), jupiter
♄ (sat), saturn
♅ (ura), uranus
♆ (nep), neptune
♇ (plu), pluto
Asc (asc), ascendant
Dec (dec), descendant
MH (mh), midheaven
IC (ic), imumCoeli
☊ (lnn), lunarAscendingNode
☋ (lsn), lunarDescendingNode
⚸ (la), lunarApogee
-⚸ (lp), lunarPerigee
Ⓧ (pof), partOfFortune
꩜ (pos), partOfSpirit
♡ (poe), partOfEros
☌ (con), conjunction
☍ (opp), opposition
△ (tri), trine
☐ (squ), square
⚹ (sex), sextile
⚻ (qui), quincunx
⚺ (s-sex), semi-sextile
∠ (s-squ), semi-square
⚼ (sesqu), sesquiquadrate
⭐︎ (qui), quintile
⭐︎² (b-qui), bi-quintile
7¹ (sep), septile
7² (b-sep), bi-septile
7³ (t-sep), tri-septile
9¹ (nov), novile
9² (b-nov), bi-novile
9⁴ (q-nov), quad-novile
10¹ (dec), decile
⌖ (coords), coordinates
D (date), date
T (time), time
↕ (lat), latitude
↔ (long), longitude
♈︎ (ari), aries
♉︎ (tau), taurus
♊︎ (gem), gemini
♋︎ (can), cancer
♌︎ (leo), leo
♍︎ (vir), virgo
♎︎ (lib), libra
♏︎ (sco), scorpio
♐︎ (sag), sagittarius
♑︎ (cap), capricorn
♒︎ (aqu), aquarius
♓︎ (pis), pisces
"""

        static let legendDictionary: [String: String] = [
            "☉": "sun (sun)",
            "☽": "moo (moon)",
            "☿": "mer (mercury)",
            "♀": "ven (venus)",
            "♁": "ear (earth)",
            "♂": "mar (mars)",
            "♃": "jup (jupiter)",
            "♄": "sat (saturn)",
            "♅": "ura (uranus)",
            "♆": "nep (neptune)",
            "♇": "plu (pluto)",
            "Asc": "asc (ascendant)",
            "Dec": "dec (descendant)",
            "MH": "mh (midheaven)",
            "IC": "ic (imumCoeli)",
            "☊": "lnn (lunarAscendingNode)",
            "☋": "lsn (lunarDescendingNode)",
            "⚸": "la (lunarApogee)",
            "-⚸": "lp (lunarPerigee)",
            "Ⓧ": "pof (partOfFortune)",
            "꩜": "pos (partOfSpirit)",
            "♡": "poe (partOfEros)",
            "☌": "con (conjunction)",
            "☍": "opp (opposition)",
            "△": "tri (trine)",
            "☐": "squ (square)",
            "⚹": "sex (sextile)",
            "⚻": "qui (quincunx)",
            "⚺": "s-sex (semi-sextile)",
            "∠": "s-squ (semi-square)",
            "⚼": "sesqu (sesquiquadrate)",
            "⭐︎": "qui (quintile)",
            "⭐︎²": "b-qui (bi-quintile)",
            "7¹": "sep (septile)",
            "7²": "b-sep (bi-septile)",
            "7³": "t-sep (tri-septile)",
            "9¹": "nov (novile)",
            "9²": "b-nov (bi-novile)",
            "9⁴": "q-nov (quad-novile)",
            "10¹": "dec (decile)",
            "⌖": "coords (coordinates)",
            "D": "date (date)",
            "T": "time (time)",
            "↕": "lat (latitude)",
            "↔": "long (longitude)",
            "♈︎": "ari (aries)",
            "♉︎": "tau (taurus)",
            "♊︎": "gem (gemini)",
            "♋︎": "can (cancer)",
            "♌︎": "leo (leo)",
            "♍︎": "vir (virgo)",
            "♎︎": "lib (libra)",
            "♏︎": "sco (scorpio)",
            "♐︎": "sag (sagittarius)",
            "♑︎": "cap (capricorn)",
            "♒︎": "aqu (aquarius)",
            "♓︎": "pis (pisces)"
        ]
        
        static let verboseLegendDictionary: [String: [String: String]] = [
            "☉": ["symbol": "sun", "description": "The symbol for the sun, representing vitality and the core self."],
            "☽": ["symbol": "moon", "description": "The symbol for moon, representing emotions, intuition, and the subconscious."],
            "☿": ["symbol": "mercury", "description": "The symbol for mercury, associated with communication and intellect."],
            "♀": ["symbol": "venus", "description": "The symbol for venus, representing love, beauty, and harmony."],
            "♁": ["symbol": "earth", "description": "The symbol for earth, signifying grounding and stability."],
            "♂": ["symbol": "mars", "description": "The symbol for mars, representing energy, drive, and assertiveness."],
            "♃": ["symbol": "jupiter", "description": "The symbol for jupiter, associated with expansion and growth."],
            "♄": ["symbol": "saturn", "description": "The symbol for saturn, signifying structure, discipline, and responsibility."],
            "♅": ["symbol": "uranus", "description": "The symbol for uranus, representing innovation and change."],
            "♆": ["symbol": "neptune", "description": "The symbol for neptune, associated with dreams, intuition, and mysticism."],
            "♇": ["symbol": "pluto", "description": "The symbol for pluto, signifying transformation and rebirth."],
            "Asc": ["symbol": "ascendant", "description": "The symbol for ascendant, representing one's outward personality and appearance."],
            "Dec": ["symbol": "descendant", "description": "The symbol for descendant, signifying one's partnerships and relationships."],
            "MH": ["symbol": "midheaven", "description": "The symbol for midheaven, associated with one's career and public life."],
            "IC": ["symbol": "imumCoeli", "description": "The symbol for imum coeli, signifying one's innermost self and roots."],
            "☊": ["symbol": "lunarAscendingNode", "description": "The symbol for lunar ascending node, representing one's karmic path and growth."],
            "☋": ["symbol": "lunarDescendingNode", "description": "The symbol for lunar descending node, signifying release and letting go."],
            "⚸": ["symbol": "lunarApogee", "description": "The symbol for lunar apogee, associated with the farthest point in the moon's orbit from Earth."],
            "-⚸": ["symbol": "lunarPerigee", "description": "The symbol for lunar perigee, signifying the closest point in the moon's orbit to Earth."],
            "Ⓧ": ["symbol": "partOfFortune", "description": "The symbol for part of fortune, representing personal happiness and well-being."],
            "꩜": ["symbol": "partOfSpirit", "description": "The symbol for part of spirit, signifying one's spiritual journey and inner growth."],
            "♡": ["symbol": "partOfEros", "description": "The symbol for part of eros, associated with one's capacity for love and passion."],
            "☌": ["symbol": "conjunction", "description": "The symbol for conjunction, representing aspects in astrology when planets align closely (0°)."],
            "☍": ["symbol": "opposition", "description": "The symbol for opposition, signifying aspects in astrology when planets are 180° apart."],
            "△": ["symbol": "trine", "description": "The symbol for trine, associated with harmonious aspects in astrology when planets are 120° apart."],
            "☐": ["symbol": "square", "description": "The symbol for square, representing challenging aspects in astrology when planets are 90° apart."],
            "⚹": ["symbol": "sextile", "description": "The symbol for sextile, signifying harmonious aspects in astrology when planets are 60° apart."],
            "⚻": ["symbol": "quincunx", "description": "The symbol for quincunx, associated with challenging aspects in astrology when planets are 150° apart."],
            "⚺": ["symbol": "semi-sextile", "description": "The symbol for semi-sextile, representing minor aspects in astrology when planets are 30° apart."],
            "∠": ["symbol": "semi-square", "description": "The symbol for semi-square, signifying minor challenging aspects in astrology when planets are 45° apart."],
            "⚼": ["symbol": "sesquiquadrate", "description": "The symbol for sesquiquadrate, associated with challenging aspects in astrology when planets are 135° apart."],
            "⭐︎": ["symbol": "quintile", "description": "The symbol for quintile, representing aspects in astrology when planets are 72° apart."],
            "⭐︎²": ["symbol": "bi-quintile", "description": "The symbol for bi-quintile, signifying aspects in astrology when planets are 144° apart."],
            "7¹": ["symbol": "septile", "description": "The symbol for septile, associated with aspects in astrology when planets are approximately 51.43° apart."],
            "7²": ["symbol": "bi-septile", "description": "The symbol for bi-septile, signifying aspects in astrology when planets are approximately 102.86° apart."],
            "7³": ["symbol": "tri-septile", "description": "The symbol for tri-septile, representing aspects in astrology when planets are approximately 154.29° apart."],
            "9¹": ["symbol": "novile", "description": "The symbol for novile, associated with aspects in astrology when planets are 40° apart."],
            "9²": ["symbol": "bi-novile", "description": "The symbol for bi-novile, signifying aspects in astrology when planets are 80° apart."],
            "9⁴": ["symbol": "quad-novile", "description": "The symbol for quad-novile, representing aspects in astrology when planets are 160° apart."],
            "10¹": ["symbol": "decile", "description": "The symbol for decile, associated with aspects in astrology when planets are 36° apart."],
            "⌖": ["symbol": "coordinates", "description": "The symbol for coordinates, representing latitude and longitude in astrology."],
            "D": ["symbol": "date", "description": "The symbol for date, signifying calendar dates in astrology."],
            "T": ["symbol": "time", "description": "The symbol for time, associated with clock time in astrology."],
            "↕": ["symbol": "latitude", "description": "The symbol for latitude, representing the north-south position on Earth's surface."],
            "↔": ["symbol": "longitude", "description": "The symbol for longitude, signifying the east-west position on Earth's surface."],
            "♈︎": ["symbol": "aries", "description": "The symbol for aries, representing the first sign of the zodiac and associated with initiative and leadership."],
            "♉︎": ["symbol": "taurus", "description": "The symbol for taurus, signifying the second sign of the zodiac and associated with stability and sensuality."],
            "♊︎": ["symbol": "gemini", "description": "The symbol for gemini, representing the third sign of the zodiac and associated with communication and versatility."],
            "♋︎": ["symbol": "cancer", "description": "The symbol for cancer, signifying the fourth sign of the zodiac and associated with home and emotions."],
            "♌︎": ["symbol": "leo", "description": "The symbol for leo, representing the fifth sign of the zodiac and associated with creativity and self-expression."],
            "♍︎": ["symbol": "virgo", "description": "The symbol for virgo, signifying the sixth sign of the zodiac and associated with precision and practicality."],
            "♎︎": ["symbol": "libra", "description": "The symbol for libra, representing the seventh sign of the zodiac and associated with balance and relationships."],
            "♏︎": ["symbol": "scorpio", "description": "The symbol for scorpio, signifying the eighth sign of the zodiac and associated with transformation and intensity."],
            "♐︎": ["symbol": "sagittarius", "description": "The symbol for sagittarius, representing the ninth sign of the zodiac and associated with adventure and exploration."],
            "♑︎": ["symbol": "capricorn", "description": "The symbol for capricorn, signifying the tenth sign of the zodiac and associated with ambition and responsibility."],
            "♒︎": ["symbol": "aquarius", "description": "The symbol for aquarius, representing the eleventh sign of the zodiac and associated with innovation and humanitarianism."],
            "♓︎": ["symbol": "pisces", "description": "The symbol for pisces, signifying the twelfth sign of the zodiac and associated with compassion and spirituality."]
        ]
        
        static let symbolArray: [String] = {
            let symbols = verboseLegendDictionary.keys
            return Array(symbols)
        }()

        static let verboseTxtLegend: String = """
Legend:
☉ (sun): The symbol for the sun, representing vitality and the core self.
☽ (moo): The symbol for the moon, representing emotions, intuition, and the subconscious.
☿ (mer): The symbol for mercury, associated with communication and intellect.
♀ (ven): The symbol for venus, representing love, beauty, and harmony.
♁ (ear): The symbol for earth, signifying grounding and stability.
♂ (mar): The symbol for mars, representing energy, drive, and assertiveness.
♃ (jup): The symbol for jupiter, associated with expansion and growth.
♄ (sat): The symbol for saturn, signifying structure, discipline, and responsibility.
♅ (ura): The symbol for uranus, representing innovation and change.
♆ (nep): The symbol for neptune, associated with dreams, intuition, and mysticism.
♇ (plu): The symbol for pluto, signifying transformation and rebirth.
Asc (asc): The symbol for ascendant, representing one's outward personality and appearance.
Dec (dec): The symbol for descendant, signifying one's partnerships and relationships.
MH (mh): The symbol for midheaven, associated with one's career and public life.
IC (ic): The symbol for imum coeli, signifying one's innermost self and roots.
☊ (lnn): The symbol for lunar ascending node, representing one's karmic path and growth.
☋ (lsn): The symbol for lunar descending node, signifying release and letting go.
⚸ (la): The symbol for lunar apogee, associated with the farthest point in the moon's orbit from Earth.
-⚸ (lp): The symbol for lunar perigee, signifying the closest point in the moon's orbit to Earth.
Ⓧ (pof): The symbol for part of fortune, representing personal happiness and well-being.
꩜ (pos): The symbol for part of spirit, signifying one's spiritual journey and inner growth.
♡ (poe): The symbol for part of eros, associated with one's capacity for love and passion.
☌ (con): The symbol for conjunction, representing aspects in astrology when planets align closely (0°).
☍ (opp): The symbol for opposition, signifying aspects in astrology when planets are 180° apart.
△ (tri): The symbol for trine, associated with harmonious aspects in astrology when planets are 120° apart.
☐ (squ): The symbol for square, representing challenging aspects in astrology when planets are 90° apart.
⚹ (sex): The symbol for sextile, signifying harmonious aspects in astrology when planets are 60° apart.
⚻ (qui): The symbol for quincunx, associated with challenging aspects in astrology when planets are 150° apart.
⚺ (s-sex): The symbol for semi-sextile, representing minor aspects in astrology when planets are 30° apart.
∠ (s-squ): The symbol for semi-square, signifying minor challenging aspects in astrology when planets are 45° apart.
⚼ (sesqu): The symbol for sesquiquadrate, associated with challenging aspects in astrology when planets are 135° apart.
⭐︎ (qui): The symbol for quintile, representing aspects in astrology when planets are 72° apart.
⭐︎² (b-qui): The symbol for bi-quintile, signifying aspects in astrology when planets are 144° apart.
7¹ (sep): The symbol for septile, associated with aspects in astrology when planets are approximately 51.43° apart.
7² (b-sep): The symbol for bi-septile, signifying aspects in astrology when planets are approximately 102.86° apart.
7³ (t-sep): The symbol for tri-septile, representing aspects in astrology when planets are approximately 154.29° apart.
9¹ (nov): The symbol for novile, associated with aspects in astrology when planets are 40° apart.
9² (b-nov): The symbol for bi-novile, signifying aspects in astrology when planets are 80° apart.
9⁴ (q-nov): The symbol for quad-novile, representing aspects in astrology when planets are 160° apart.
10¹ (dec): The symbol for decile, associated with aspects in astrology when planets are 36° apart.
⌖ (coords): The symbol for coordinates, representing latitude and longitude in astrology.
D (date): The symbol for date, signifying calendar dates in astrology.
T (time): The symbol for time, associated with clock time in astrology.
↕ (lat): The symbol for latitude, representing the north-south position on Earth's surface.
↔ (long): The symbol for longitude, signifying the east-west position on Earth's surface.
♈︎ (ari): The symbol for aries, representing the first sign of the zodiac and associated with initiative and leadership.
♉︎ (tau): The symbol for taurus, signifying the second sign of the zodiac and associated with stability and sensuality.
♊︎ (gem): The symbol for gemini, representing the third sign of the zodiac and associated with communication and versatility.
♋︎ (can): The symbol for cancer, signifying the fourth sign of the zodiac and associated with home and emotions.
♌︎ (leo): The symbol for leo, representing the fifth sign of the zodiac and associated with creativity and self-expression.
♍︎ (vir): The symbol for virgo, signifying the sixth sign of the zodiac and associated with precision and practicality.
♎︎ (lib): The symbol for libra, representing the seventh sign of the zodiac and associated with balance and relationships.
♏︎ (sco): The symbol for scorpio, signifying the eighth sign of the zodiac and associated with transformation and intensity.
♐︎ (sag): The symbol for sagittarius, representing the ninth sign of the zodiac and associated with adventure and exploration.
♑︎ (cap): The symbol for capricorn, signifying the tenth sign of the zodiac and associated with ambition and responsibility.
♒︎ (aqu): The symbol for aquarius, representing the eleventh sign of the zodiac and associated with innovation and humanitarianism.
♓︎ (pis): The symbol for pisces, signifying the twelfth sign of the zodiac and associated with compassion and spirituality.
"""
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
