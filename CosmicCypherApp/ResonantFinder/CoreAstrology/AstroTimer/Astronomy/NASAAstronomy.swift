//
//  Astronomy.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/13/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation

class NASAAstronomy {
    
    enum Month : String {
        case jan
        case feb
        case mar
        case apr
        case may
        case jun
        case jul
        case aug
        case sep
        case nov
        case dec
    }
    
    enum Planet : String {
        case mercury
        case venus
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
    }
    
    enum StarZone : String {
        case spicia
        case antares
        case pleiades
        case pollux
        case beehive
        case aldebaran
        case regulus
    }
    
    enum LunarOrbit : String  {
        case ascendingNode
        case perigee
        case northDec
        case decendingNode
        case apogee
        case southDec
    }
    
    enum PlanetaryAlignment : String {
        case Opposition
        case Conjunction
        case Elongation
        case SuperiorConjunction
        case InferiorConjunction
    }
    
    enum LunarProgression : String {
        case new = "New Moon"
        case first = "First Quarter"
        case full = "Full Moon"
        case last = "Last Quarter"
    }
    
    enum Polarity : String {
        case east
        case south
        case west
        case north
    }
    
    enum Eclipse {
        case lunar(LunarEclipseType)
        case solar(SolarEclipseType)
    }
    
    enum SolarEclipseType : String {
        case total
        case annular
        case hybrid
        case partial
        case possible
    }
    
    enum LunarEclipseType : String  {
        case total
        case partial
        case pen
    }
    
    enum Shower {
        case quadrantids(ZHR)
        case lyrids(ZHR)
        case etaAquarids(ZHR)
        case deltaAquarids(ZHR)
        case perseid(ZHR)
        case orionid(ZHR)
        case southTaurids(ZHR)
        case northTaurids(ZHR)
        case leonids(ZHR)
        case geminids(ZHR)
        case ursids(ZHR)
    }
    
    /// The ZHR (Zenithal Hourly Rate) is an estimate of the number of shower meteors that would be seen by a single observer, watching an unobstructed area of the sky for a period of one hour, with the shower's radiant at the zenith and a limiting magnitude of 6.5.
    typealias ZHR = Int
    typealias KM = Double
    typealias AU = Double
    typealias Degrees = Double
    
    enum EventType {
        case perihelion(KM)
        case aphelion(KM)
        case winterSolstice
        case springEquinox
        case summerSolstice
        case fallEquinox
        case newMonth(Month, Degrees, Polarity)
        case lunar(LunarProgression)
        case lunarOrbit(LunarOrbit)
        case lunarPlanet(Planet, Degrees, Polarity)
        case lunarStarZone(StarZone, Degrees, Polarity)
        case planetaryConjunction(Planet)
        case planetPlanet(Planet, Planet, Degrees, Polarity)
        case planetStarZone(Planet, StarZone, Degrees, Polarity)
        case planetary(PlanetaryAlignment)
        case shower(ZHR)
    }
    
    
    struct AstronomicalMonth {
        let month:NASAAstronomy.Month
        var events:[AstronomicalEvent]
    }
    
    struct AstronomicalEvent {
        
        let date:Date?
        let eventType:EventType?
        
        
    }
    
}


// For Parsing v2018 NASA Astronomy Charts
class AstronomyParser {
    
    static func convertTextToAstrologicalEventArray(year:Int, text:String) {//}-> [Astronomy.Month:[Astronomy.AstronomicalEvent]]? {
        
        guard let lines = regex(.line, text) else { return }//nil }
        
        
        var currentMonth:NASAAstronomy.Month = .jan
        var currentMonthsEvents:[NASAAstronomy.Month:[NASAAstronomy.AstronomicalEvent]] = [:]
        
        for line in lines {
            if let monthString = regex(.month, line)?.first?.stringRemovingAfter(index: 3),
                let month = NASAAstronomy.Month(rawValue: monthString.lowercased()) {
                currentMonth = month
            } else if let eventString = regex1(.event, line) {
                
                let fullDayString = regex1(.eventDayFull, eventString)!
                let dayString = regex1(.eventDayNumber, fullDayString)!
                let day = Int(dayString)
                
                let timeString = regex1(.eventTime, eventString)!
                let timeParts:[String] = timeString.components(separatedBy: ":")
                let hrString = timeParts.first
                let hr = Int(hrString!)
                let minString = timeParts.count > 1 ? timeParts[1] : nil
                let min = Int(minString!)
                
                let date = Date(year: year,
                                month: currentMonth.hashValue,
                                day: day!,
                                timeZone: TimeZone(abbreviation: "PST")!,
                                hour: hr!,
                                minute: min!)
                
                if let eventDetailsString = regex1(.eventDetails, eventString) {
                    
                    // Separate the event name/title from the value it references
                    let details:[String] = eventDetailsString.components(separatedBy: ": ")
                    
                    // Prepare holders for potential values
                    var polarity:NASAAstronomy.Polarity?
                    var value:Double?
                    var eventType:NASAAstronomy.EventType?
                    
                    // Check if there is a value for the event
                    if let eventDetailValueString = details.count > 1 ? details[1] : nil,
                        let eventDetailValue = regex("\\d+", eventDetailValueString) {
                        /*
                        if eventDetailValueString.last?.uppercased() == "N" { polarity = .north }
                        if eventDetailValueString.last?.uppercased() == "S" { polarity = .south }
                        if eventDetailValueString.last?.uppercased() == "E" { polarity = .east }
                        if eventDetailValueString.last?.uppercased() == "W" { polarity = .west }
                        */
                    }
                    
                    if let eventString = details.first?.lowercased() {
                        if eventString.contains("moon") {
                            if eventString.contains("new") { eventType = .lunar(.new) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("first") {  eventType = .lunar(.first) }
                            else if eventString.contains("last") {  eventType = .lunar(.last) }
                            else if eventString.contains("descending") {  eventType = .lunarOrbit(.decendingNode) }
                            else if eventString.contains("ascending") {  eventType = .lunarOrbit(.ascendingNode) }
                            else if eventString.contains("apogee") {  eventType = .lunarOrbit(.apogee) }
                            else if eventString.contains("south dec") {  eventType = .lunarOrbit(.southDec) }
                            else if eventString.contains("perigee") {  eventType = .lunarOrbit(.perigee) }
                            else if eventString.contains("north dec") {  eventType = .lunarOrbit(.northDec) }
                            //else if eventString.contains("mercury") {  eventType = .lunarPlanet(.mercury, <#T##AstronomicalEvent.Degrees#>, <#T##AstronomicalEvent.Polarity#>) }
                            else if eventString.contains("venus") {  eventType = .lunar(.full) }
                            else if eventString.contains("earth") {  eventType = .lunar(.full) }
                            else if eventString.contains("mars") {  eventType = .lunar(.full) }
                            else if eventString.contains("jupiter") {  eventType = .lunar(.full) }
                            else if eventString.contains("saturn") {  eventType = .lunar(.full) }
                            else if eventString.contains("uranus") {  eventType = .lunar(.full) }
                            else if eventString.contains("neptune") {  eventType = .lunar(.full) }
                            else if eventString.contains("beehive") {  eventType = .lunar(.full) }
                            else if eventString.contains("pollux") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("full") {  eventType = .lunar(.full) }
                            else if eventString.contains("mercury") {
                                
                            } else if eventString.contains("venus") {
                                
                            } else if eventString.contains("mercury") {
                                
                            } else if eventString.contains("venus") {
                                
                            } else if eventString.contains("earth") {
                                
                            } else if eventString.contains("mars") {
                                
                            } else if eventString.contains("jupiter") {
                                
                            } else if eventString.contains("saturn") {
                                
                            } else if eventString.contains("uranus") {
                                
                            } else if eventString.contains("neptune") {
                                
                            } else if eventString.contains("beehive") {
                                
                            } else if eventString.contains("pollux") {
                                
                            } else if eventString.contains("antares") {
                                
                            } else if eventString.contains("spica") {
                                
                            } else if eventString.contains("pleiades") {
                                
                            }
                            
                        } else if eventString.contains("quarter") {
                            if eventString.contains("last") {
                                
                            } else if eventString.contains("first") {
                                
                            }
                        } else if eventString.contains("mercury") {
                            if eventString.contains("venus") {
                                
                            } else if eventString.contains("mercury") {
                                
                            } else if eventString.contains("venus") {
                                
                            } else if eventString.contains("mars") {
                                
                            } else if eventString.contains("jupiter") {
                                
                            } else if eventString.contains("saturn") {
                                
                            }
                        } else if eventString.contains("venus") {
                            if eventString.contains("mercury") {
                                
                            } else if eventString.contains("venus") {
                                
                            } else if eventString.contains("mars") {
                                
                            } else if eventString.contains("jupiter") {
                                
                            } else if eventString.contains("saturn") {
                                
                            }
                        } else if eventString.contains("mercury") {
                            if eventString.contains("venus") {
                                
                            } else if eventString.contains("mars") {
                                
                            } else if eventString.contains("jupiter") {
                                
                            } else if eventString.contains("saturn") {
                                
                            }
                        } else if eventString.contains("venus") {
                            if eventString.contains("mars") {
                                
                            } else if eventString.contains("jupiter") {
                                
                            } else if eventString.contains("saturn") {
                                
                            }
                        } else if eventString.contains("mars") {
                            if eventString.contains("jupiter") {
                                
                            } else if eventString.contains("saturn") {
                                
                            }
                        } else if eventString.contains("jupiter") {
                            if eventString.contains("saturn") {
                                
                            }
                        } else if eventString.contains("saturn") {
                            
                        } else if eventString.contains("uranus") {
                            
                        } else if eventString.contains("neptune") {
                            
                        }else if eventString.contains("shower") {
                            
                        } else if details.contains("solar eclipse") {
                            
                        } else if details.contains("lunar eclipse") {
                            
                        }
                        
                    }
                    /*
                    if let event:AstronomicalEvent = AstronomicalEvent(date: date!, eventType: eventType) {
                        if currentMonthsEvents[currentMonth] == nil { currentMonthsEvents[currentMonth] = [] }
                        currentMonthsEvents[currentMonth]?.append(event)
                    }*/
                    
                }
            } else {
                
            }
        }
    }
    
    enum NASAAstronomyRegex: String {
    case month = "\\w\\w\\w    \\d\\d     \\w\\w        \\w+: .+"
    case event = "     \\d\\d     \\w\\w    \\d\\d:\\d\\d    [\\w -.]+:? .+?"
    case eventDayFull = "     \\d\\d     \\w\\w    "
    case eventDayNumber = "\\d\\d"
    case eventTime = "\\d\\d:\\d\\d"
    case eventDetails = "    [\\w -.]+:? .+?"
    case line = ".+\\n"
    }
    
    static func regex(_ regex:NASAAstronomyRegex, _ text:String) -> [String]? {
        let matches = Regex.matches(regex.rawValue, in: text)
        return matches.count > 0 ? matches : nil
    }
    
    static func regex(_ regex:String, _ text:String) -> [String]? {
        let matches = Regex.matches(regex, in: text)
        return matches.count > 0 ? matches : nil
    }
    
    static func regex1(_ regex:NASAAstronomyRegex, _ text:String) -> String? {
        let matches = Regex.matches(regex.rawValue, in: text)
        return matches.first
    }
    
}
