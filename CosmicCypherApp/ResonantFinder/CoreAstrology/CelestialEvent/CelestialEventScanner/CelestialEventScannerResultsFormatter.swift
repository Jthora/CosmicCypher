//
//  CelestialEventScannerResultsFormatter.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/30/23.
//

import Foundation

extension CelestialEventScanner.Results {
    struct Formatter {
        
        // MARK: Format
        static func format(results: CelestialEventScanner.Results, exportMode: CelestialEventExporter.ExportMode, formatOption:Option, includeLegend:Bool, verbose:Bool) -> String {
            switch exportMode {
            case.json: return formatJSON(results: results, formatOption:formatOption, includeLegend:includeLegend, verbose:verbose)
            case.txt: return formatTXT(data: results.data, formatOption:formatOption, includeLegend:includeLegend, verbose:verbose)
            }
        }
        
        // MARK: Formatters
        static func formatJSON(results: CelestialEventScanner.Results, formatOption:Option, includeLegend:Bool, verbose:Bool) -> String {
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
                        case .words: formattedString += "Date "
                        case .letters, .symbols: formattedString += "D"
                        }
                    }
                } else {
                    // Format Time for Verbose
                    if verbose {
                        formattedKey
                        // Format Time for Key
                        switch formatOption {
                        case .words:
                            formattedKey = formattedKey.replacingOccurrences(of: "T", with: "Time ")
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
            case "moon": return "☾"
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
            case "lunarApogee": return "☾̥"
            case "lunarPerigee": return "☾̇"
            case "partOfFortune": return "Ⓧ"
            case "partOfSpirit": return "꩜"
            case "partOfEros": return "♡"
                // Primary Aspects
            case "conjunction": return "☌" // 0°
            case "opposition": return "☍" // 180°
            case "trine": return "△" // 120°
            case "square": return "☐" // 90°
            case "sextile": return "✱" // 60°
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
            case "☾": return "moon"
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
            case "☾̥": return "lunarApogee"
            case "☾̇": return "lunarPerigee"
            case "Ⓧ": return "partOfFortune"
            case "꩜": return "partOfSpirit"
            case "♡": return "partOfEros"
                // Primary Aspects
            case "☌": return "conjunction"
            case "☍": return "opposition"
            case "△": return "trine"
            case "☐": return "square"
            case "✱": return "sextile"
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
            case "8¹": return "octile"
            case "8³": return "tri-octile"
            case "9¹": return "novile"
            case "9²": return "bi-novile"
            case "9⁴": return "quad-novile"
            case "10¹": return "decile"
            case "11¹": return "undecile"
            case "11²": return "duo-undecile"
            case "11³": return "tri-undecile"
            case "11⁴": return "quad-undecile"
            case "11⁵": return "quinque-undecile"
            case "12¹": return "duodecile"
            case "12⁵": return "quinque-duodecile"
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
            case "☾": return "moo"
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
            case "☾̥": return "la"
            case "☾̇": return "lp"
            case "Ⓧ": return "pof"
            case "꩜": return "pos"
            case "♡": return "poe"
                // Primary Aspects
            case "☌": return "con"
            case "☍": return "opp"
            case "△": return "tri"
            case "☐": return "squ"
            case "✱": return "sex"
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
            case "8¹": return "oct"
            case "8³": return "t-oct"
            case "9¹": return "nov"
            case "9²": return "b-nov"
            case "9⁴": return "q-nov"
            case "10¹": return "dec"
            case "11¹": return "udec"
            case "11²": return "d-udec"
            case "11³": return "t-udec"
            case "11⁴": return "q-udec"
            case "11⁵": return "q-udec"
            case "12¹": return "ddec"
            case "12⁵": return "q-ddec"
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
☾ (moo), moon
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
☾̥ (la), lunarApogee
☾̇ (lp), lunarPerigee
Ⓧ (pof), partOfFortune
꩜ (pos), partOfSpirit
♡ (poe), partOfEros
☌ (con), conjunction
☍ (opp), opposition
△ (tri), trine
☐ (squ), square
✱ (sex), sextile
⚻ (qui), quincunx
⚺ (s-sex), semi-sextile
∠ (s-squ), semi-square
⚼ (sesqu), sesquiquadrate
⭐︎ (qui), quintile
⭐︎² (b-qui), bi-quintile
7¹ (sep), septile
7² (b-sep), bi-septile
7³ (t-sep), tri-septile
8¹ (oct), octile
8³ (t-oct), tri-octile
9¹ (nov), novile
9² (b-nov), bi-novile
9⁴ (q-nov), quad-novile
10¹ (dec), decile
11¹ (udec), undecile
11² (d-udec), duo-undecile
11³ (t-udec), tri-undecile
11⁴ (quad-udec), quad-undecile
11⁵ (quin-udec), quinque-undecile
12¹ (ddec), duodecile
12⁵ (q-ddec), quinque-duodecile
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
            "☾": "moo (moon)",
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
            "☾̥": "la (lunarApogee)",
            "☾̇": "lp (lunarPerigee)",
            "Ⓧ": "pof (partOfFortune)",
            "꩜": "pos (partOfSpirit)",
            "♡": "poe (partOfEros)",
            "☌": "con (conjunction)",
            "☍": "opp (opposition)",
            "△": "tri (trine)",
            "☐": "squ (square)",
            "✱": "sex (sextile)",
            "⚻": "qui (quincunx)",
            "⚺": "s-sex (semi-sextile)",
            "∠": "s-squ (semi-square)",
            "⚼": "sesqu (sesquiquadrate)",
            "⭐︎": "qui (quintile)",
            "⭐︎²": "b-qui (bi-quintile)",
            "7¹": "sep (septile)",
            "7²": "b-sep (bi-septile)",
            "7³": "t-sep (tri-septile)",
            "8¹": "oct (octile)",
            "8³": "t-oct (tri-octile)",
            "9¹": "nov (novile)",
            "9²": "b-nov (bi-novile)",
            "9⁴": "q-nov (quad-novile)",
            "10¹": "dec (decile)",
            "11¹": "udec (undecile)",
            "11²": "d-udec (duo-undecile)",
            "11³": "t-udec (tri-undecile)",
            "11⁴": "quad-udec (quad-undecile)",
            "11⁵": "quin-udec (quinque-undecile)",
            "12¹": "ddec (duodecile)",
            "12⁵": "quin-ddec (quinque-duodecile)",
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
            "☾": ["symbol": "moon", "description": "The symbol for moon, representing emotions, intuition, and the subconscious."],
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
            "☾̥": ["symbol": "lunarApogee", "description": "The symbol for lunar apogee, associated with the farthest point in the moon's orbit from Earth."],
            "☽̇": ["symbol": "lunarPerigee", "description": "The symbol for lunar perigee, signifying the closest point in the moon's orbit to Earth."],
            "Ⓧ": ["symbol": "partOfFortune", "description": "The symbol for part of fortune, representing personal happiness and well-being."],
            "꩜": ["symbol": "partOfSpirit", "description": "The symbol for part of spirit, signifying one's spiritual journey and inner growth."],
            "♡": ["symbol": "partOfEros", "description": "The symbol for part of eros, associated with one's capacity for love and passion."],
            "☌": [
              "symbol": "conjunction",
              "description": "Represents aspects in astrology when planets align closely (0°). This aspect signifies a strong connection, often intensifying the qualities of the planets involved."
            ],
            "☍": [
              "symbol": "opposition",
              "description": "Represents aspects in astrology when planets are 180° apart. This aspect signifies a need for balance and compromise, as opposing forces seek equilibrium."
            ],
            "△": [
              "symbol": "trine",
              "description": "Represents aspects in astrology when planets are 120° apart. This aspect brings ease and flow between planets, indicating natural talents, cooperation, and positive outcomes."
            ],
            "☐": [
              "symbol": "square",
              "description": "Represents challenging aspects in astrology when planets are 90° apart. This aspect suggests conflicts, obstacles, and the need for growth through overcoming difficulties."
            ],
            "✱": [
              "symbol": "sextile",
              "description": "Represents harmonious aspects in astrology when planets are 60° apart. This aspect signifies cooperation, creativity, and a chance to pursue one's desires."
            ],
            "⚻": [
              "symbol": "quincunx",
              "description": "Represents challenging aspects in astrology when planets are 150° apart, signifying aspects requiring adjustment and adaptation."
            ],
            "⚺": [
              "symbol": "semi-sextile",
              "description": "Represents minor aspects in astrology when planets are 30° apart. This aspect suggests subtle support and opportunities for growth through cooperation."
            ],
            "∠": [
              "symbol": "semi-square",
              "description": "Represents minor challenging aspects in astrology when planets are 45° apart. This aspect indicates some friction and the need to work on minor conflicts."
            ],
            "⚼": [
              "symbol": "sesquiquadrate",
              "description": "Represents challenging aspects in astrology when planets are 135° apart. This aspect implies the need for adjustments and fine-tuning to achieve balance."
            ],
            "⭐︎": [
              "symbol": "quintile",
              "description": "Represents aspects in astrology when planets are 72° apart. This aspect suggests the potential for innovation and originality."
            ],
            "⭐︎²": [
              "symbol": "bi-quintile",
              "description": "Represents aspects in astrology when planets are 144° apart, signifying unique creative talents and opportunities for self-expression."
            ],
            "7¹": [
              "symbol": "septile",
              "description": "Associated with aspects in astrology when planets are approximately 51.43° apart, indicating mystical and intuitive connections."
            ],
            "7²": [
              "symbol": "bi-septile",
              "description": "Represents aspects in astrology when planets are approximately 102.86° apart, emphasizing profound and unusual insights."
            ],
            "7³": [
              "symbol": "tri-septile",
              "description": "Represents aspects in astrology when planets are approximately 154.29° apart, signifying deep spiritual growth and lessons."
            ],
            "8¹": [
              "symbol": "octile",
              "description": "Represents aspects in astrology when planets are 45° apart, indicating minor challenges and opportunities for growth."
            ],
            "8³": [
              "symbol": "tri-octile",
              "description": "Associated with aspects in astrology when planets are 135° apart, signifying the need for deep inner work and personal growth."
            ],
            "9¹": [
              "symbol": "novile",
              "description": "Associated with aspects in astrology when planets are 40° apart, signifying subtle and profound insights."
            ],
            "9²": [
              "symbol": "bi-novile",
              "description": "Represents aspects in astrology when planets are 80° apart, emphasizing hidden talents and the need to explore one's potential."
            ],
            "9⁴": [
              "symbol": "quad-novile",
              "description": "Represents aspects in astrology when planets are 160° apart, signifying a profound journey of self-discovery."
            ],
            "10¹": [
              "symbol": "decile",
              "description": "Associated with aspects in astrology when planets are 36° apart, indicating unique skills and opportunities for success."
            ],
            "11¹": [
              "symbol": "undecile",
              "description": "Represents aspects in astrology when planets are approximately 32.73° apart, signifying unique and unconventional qualities."
            ],
            "11²": [
              "symbol": "duo-undecile",
              "description": "Represents aspects in astrology when planets are approximately 65.45° apart, emphasizing the development of unconventional talents and ideas."
            ],
            "11³": [
              "symbol": "tri-undecile",
              "description": "Associated with aspects in astrology when planets are approximately 98.18° apart, signifying a deep and transformative journey of self-discovery."
            ],
            "11⁴": [
              "symbol": "quad-undecile",
              "description": "Represents aspects in astrology when planets are approximately 130.91° apart, highlighting unique and transformative experiences."
            ],
            "11⁵": [
              "symbol": "quinque-undecile",
              "description": "Represents aspects in astrology when planets are approximately 163.64° apart, emphasizing the development of unique and unconventional talents."
            ],
            "12¹": [
              "symbol": "duodecile",
              "description": "Associated with aspects in astrology when planets are 30° apart, indicating subtle but profound connections."
            ],
            "12⁵": [
              "symbol": "quinque-duodecile",
              "description": "Represents aspects in astrology when planets are 150° apart, signifying aspects requiring spiritual and inner transformation. This aspect suggests a deep and meaningful inner journey."
            ],
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
☾ (moo): The symbol for the moon, representing emotions, intuition, and the subconscious.
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
☾̥ (la): The symbol for lunar apogee, associated with the farthest point in the moon's orbit from Earth.
☾̇ (lp): The symbol for lunar perigee, signifying the closest point in the moon's orbit to Earth.
Ⓧ (pof): The symbol for part of fortune, representing personal happiness and well-being.
꩜ (pos): The symbol for part of spirit, signifying one's spiritual journey and inner growth.
♡ (poe): The symbol for part of eros, associated with one's capacity for love and passion.
☌ (con): The symbol for conjunction, represents aspects in astrology when planets align closely (0°). This aspect signifies a strong connection, often intensifying the qualities of the planets involved.
☍ (opp): The symbol for opposition, represents aspects in astrology when planets are 180° apart. This aspect signifies a need for balance and compromise, as opposing forces seek equilibrium.
△ (tri): The symbol for trine, represents aspects in astrology when planets are 120° apart. This aspect brings ease and flow between planets, indicating natural talents, cooperation, and positive outcomes.
☐ (squ): The symbol for square, represents challenging aspects in astrology when planets are 90° apart. This aspect suggests conflicts, obstacles, and the need for growth through overcoming difficulties.
✱ (sex): The symbol for sextile, represents harmonious aspects in astrology when planets are 60° apart. This aspect signifies cooperation, creativity, and a chance to pursue one's desires.
⚻ (qui): The symbol for quincunx, represents challenging aspects in astrology when planets are 150° apart, signifying aspects requiring adjustment and adaptation.
⚺ (s-sex): The symbol for semi-sextile, represents minor aspects in astrology when planets are 30° apart. This aspect suggests subtle support and opportunities for growth through cooperation.
∠ (s-squ): The symbol for semi-square, represents minor challenging aspects in astrology when planets are 45° apart. This aspect indicates some friction and the need to work on minor conflicts.
⚼ (sesqu): The symbol for sesquiquadrate, represents challenging aspects in astrology when planets are 135° apart. This aspect implies the need for adjustments and fine-tuning to achieve balance.
⭐︎ (qui): The symbol for quintile, represents aspects in astrology when planets are 72° apart. This aspect suggests the potential for innovation and originality.
⭐︎² (b-qui): The symbol for bi-quintile, represents aspects in astrology when planets are 144° apart, signifying unique creative talents and opportunities for self-expression.
7¹ (sep): The symbol for septile, represents aspects in astrology when planets are approximately 51.43° apart, indicating mystical and intuitive connections.
7² (b-sep): The symbol for bi-septile, represents aspects in astrology when planets are approximately 102.86° apart, emphasizing profound and unusual insights.
7³ (t-sep): The symbol for tri-septile, represents aspects in astrology when planets are approximately 154.29° apart, signifying deep spiritual growth and lessons.
8¹ (oct): The symbol for octile, represents aspects in astrology when planets are 45° apart, indicating minor challenges and opportunities for growth.
8³ (t-oct): The symbol for tri-octile, represents aspects in astrology when planets are 135° apart, signifying the need for deep inner work and personal growth.
9¹ (nov): The symbol for novile, represents aspects in astrology when planets are 40° apart, signifying subtle and profound insights.
9² (b-nov): The symbol for bi-novile, represents aspects in astrology when planets are 80° apart, emphasizing hidden talents and the need to explore one's potential.
9⁴ (q-nov): The symbol for quad-novile, represents aspects in astrology when planets are 160° apart, signifying a profound journey of self-discovery.
10¹ (dec): The symbol for decile, represents aspects in astrology when planets are 36° apart, indicating unique skills and opportunities for success.
11¹ (udec): The symbol for undecile, represents aspects in astrology when planets are approximately 32.73° apart, signifying unique and unconventional qualities.
11² (d-udec): The symbol for duo-undecile, represents aspects in astrology when planets are approximately 65.45° apart, emphasizing the development of unconventional talents and ideas.
11³ (t-udec): The symbol for tri-undecile, represents aspects in astrology when planets are approximately 98.18° apart, signifying a deep and transformative journey of self-discovery.
11⁴ (quad-udec): The symbol for quad-undecile, represents aspects in astrology when planets are approximately 130.91° apart, highlighting unique and transformative experiences.
11⁵ (quin-udec): The symbol for quinque-undecile, represents aspects in astrology when planets are approximately 163.64° apart, emphasizing the development of unique and unconventional talents.
12¹ (ddec): The symbol for duodecile, represents aspects in astrology when planets are 30° apart, indicating subtle but profound connections.
12⁵ (quin-ddec): The symbol for quinque-duodecile, represents aspects in astrology when planets are 150° apart, signifying aspects requiring spiritual and inner transformation. This aspect suggests a deep and meaningful inner journey.
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


extension CelestialEventScanner.Results.Formatter {
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
