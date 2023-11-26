//
//  CoreAstrology+AspectBody.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import SwiftAA
import Foundation

// MARK: Aspect Body
extension CoreAstrology {
    // Planet Node
    public struct AspectBody: Hashable, Equatable {
        
        public let equatorialCoordinates:EquatorialCoordinates
        public let type:NodeType
        
        init(equatorialCoordinates: EquatorialCoordinates, type: NodeType) {
            self.equatorialCoordinates = equatorialCoordinates
            self.type = type
        }
        
        init?(type: NodeType, date:Date) {
            guard let equatorialCoordinates = type.equatorialCoordinates(date: date) else {
                return nil
            }
            self.type = type
            self.equatorialCoordinates = equatorialCoordinates
        }
        
        public static func == (lhs: CoreAstrology.AspectBody, rhs: CoreAstrology.AspectBody) -> Bool {
            return lhs.type == rhs.type && lhs.equatorialCoordinates.alpha == rhs.equatorialCoordinates.alpha && lhs.equatorialCoordinates.delta == rhs.equatorialCoordinates.delta
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(type)
            hasher.combine(equatorialCoordinates.alpha)
            hasher.combine(equatorialCoordinates.delta)
        }
        
        public var equatorialLongitude:Degree {
            return equatorialCoordinates.alpha.inDegrees
        }
        
        public func positionAngle(relativeTo secondBody:AspectBody) -> Degree {
            equatorialCoordinates.positionAngle(relativeTo: secondBody.equatorialCoordinates)
        }
        
        public func longitudeDifference(from secondBody:AspectBody, on date:Date) -> Degree? {
            guard let l1 = self.type.geocentricLongitude(date: date),
                  let l2 = secondBody.type.geocentricLongitude(date: date) else {
                return nil
            }
            // Calculate the absolute difference between the angles
            var difference = abs(l1 - l2)
            
            // Handle the wrapping behavior
            if difference > 180 {
                difference = 360 - difference
            }
            return difference
        }
        
        public enum NodeType: Int, CaseIterable {
            case sun
            case moon
            case mercury
            case venus
            case mars
            case jupiter
            case saturn
            case uranus
            case neptune
            case pluto
            case ascendant
            case decendant
            case midheaven
            case imumCoeli
            case lunarAscendingNode
            case lunarDecendingNode
            case lunarApogee
            case lunarPerigee
            case partOfFortune
            case partOfSpirit
            case partOfEros
            
            public init?(with planet:PlanetaryBase) {
                switch planet.planetaryObject {
                case .MERCURY: self = .mercury
                case .VENUS: self = .venus
                case .MARS: self = .mars
                case .JUPITER: self = .jupiter
                case .SATURN: self = .saturn
                case .URANUS: self = .uranus
                case .NEPTUNE: self = .neptune
                default: return nil
                }
            }
            
            public var text: String {
                switch self {
                case .sun: return "Sun"
                case .moon: return "Moon"
                case .mercury: return "Mercury"
                case .venus: return "Venus"
                case .mars: return "Mars"
                case .jupiter: return "Jupiter"
                case .saturn: return "Saturn"
                case .uranus: return "Uranus"
                case .neptune: return "Neptune"
                case .pluto: return "Pluto"
                case .ascendant: return "Ascendant"
                case .decendant: return "Decendant"
                case .midheaven: return "Mid Heaven"
                case .imumCoeli: return "Imum Coeli"
                case .lunarAscendingNode: return "North Lunar Node"
                case .lunarDecendingNode: return "South Lunar Node"
                case .lunarApogee: return "Apogee Lunar Node"
                case .lunarPerigee: return "Perigee Lunar Node"
                case .partOfFortune: return "Fortune Part"
                case .partOfSpirit: return "Spirit Part"
                case .partOfEros: return "Eros Part"
                }
            }
            
            public var imageName:String {
                switch self {
                case .moon: return "AstrologyIcon_Node_Moon"
                case .sun: return "AstrologyIcon_Node_Sun"
                case .mercury: return "AstrologyIcon_Planet_Mercury"
                case .venus: return "AstrologyIcon_Planet_Venus"
                case .mars: return "AstrologyIcon_Planet_Mars"
                case .jupiter: return "AstrologyIcon_Planet_Jupiter"
                case .saturn: return "AstrologyIcon_Planet_Saturn"
                case .uranus: return "AstrologyIcon_Planet_Uranus"
                case .neptune: return "AstrologyIcon_Planet_Neptune"
                case .pluto: return "AstrologyIcon_Planet_Pluto"
                case .ascendant: return "AstrologyIcon_Node_ASC"
                case .decendant: return "AstrologyIcon_Node_DSC"
                case .midheaven: return "AstrologyIcon_Node_MC"
                case .imumCoeli: return "AstrologyIcon_Node_IC"
                case .lunarAscendingNode: return "AstrologyIcon_Node_NorthNode"
                case .lunarDecendingNode: return "AstrologyIcon_Node_SouthNode"
                case .lunarApogee: return "AstrologyIcon_Node_AntiLilith"
                case .lunarPerigee: return "AstrologyIcon_Node_Lilith"
                case .partOfFortune: return "AstrologyIcon_Part_Fortune"
                case .partOfSpirit: return "AstrologyIcon_Part_Spirit"
                case .partOfEros: return "AstrologyIcon_Part_Eros"
                }
            }
            
            public var fileNameSuffix:String {
                switch self {
                case .moon: return "moon"
                case .sun: return "sun"
                case .mercury: return "mercury"
                case .venus: return "venus"
                case .mars: return "mars"
                case .jupiter: return "jupiter"
                case .saturn: return "saturn"
                case .uranus: return "uranus"
                case .neptune: return "neptune"
                case .pluto: return "pluto"
                case .ascendant: return "asc"
                case .decendant: return "dec"
                case .midheaven: return "mc"
                case .imumCoeli: return "ic"
                case .lunarAscendingNode: return "moon_asc"
                case .lunarDecendingNode: return "moon_dec"
                case .lunarApogee: return "moon_apogee"
                case .lunarPerigee: return "moon_perigee"
                case .partOfFortune: return "pt_fortune"
                case .partOfSpirit: return "pt_spirit"
                case .partOfEros: return "pt_eros"
                }
            }
            
            public var image:StarKitImage? {
                return StarKitImage(named: imageName)
            }
            
            public var symbol:String {
                switch self {
                case .sun: return "☉"
                case .moon: return "☾"
                case .mercury: return "☿"
                case .venus: return "♀"
                case .mars: return "♂"
                case .jupiter: return "♃"
                case .saturn: return "♄"
                case .uranus: return "♅"
                case .neptune: return "♆"
                case .pluto: return "♇"
                case .ascendant: return "Asc"
                case .decendant: return "Dec"
                case .midheaven: return "MH"
                case .imumCoeli: return "IC"
                case .lunarAscendingNode: return "☊"
                case .lunarDecendingNode: return "☋"
                case .lunarApogee: return "☾̥"
                case .lunarPerigee: return "☾̇"
                case .partOfFortune: return "Ⓧ"
                case .partOfSpirit: return "꩜"
                case .partOfEros: return "♡"
                }
            }
            
            // Short Description
            var shortDescription: String {
                switch self {
                case .sun: return "Vitality, ego, and the core self."
                case .moon: return "Emotions, instincts, and the subconscious."
                case .mercury: return "Communication, intellect, and adaptability."
                case .venus: return "Love, beauty, and harmony."
                case .mars: return "Energy, passion, and assertiveness."
                case .jupiter: return "Expansion, growth, and opportunity."
                case .saturn: return "Discipline, responsibility, and challenges."
                case .uranus: return "Innovation, change, and disruption."
                case .neptune: return "Dreams, illusions, and spirituality."
                case .pluto: return "Transformation, power, and regeneration."
                case .ascendant: return "Persona, outer self, and beginnings."
                case .decendant: return "Relationships, partnerships, and others."
                case .midheaven: return "Career, ambitions, and public image."
                case .imumCoeli: return "Roots, home, and private life."
                case .lunarAscendingNode: return "Growth, connections, and karma."
                case .lunarDecendingNode: return "Release, closure, and letting go."
                case .lunarApogee: return "Farthest point in the Moon's orbit."
                case .lunarPerigee: return "Nearest point in the Moon's orbit."
                case .partOfFortune: return "Harmony, success, and well-being."
                case .partOfSpirit: return "Inner strength, wisdom, and resilience."
                case .partOfEros: return "Passionate connections and desires."
                }
            }
            
            // Description
            var description: String {
                switch self {
                case .sun: return "The Sun represents vitality, ego, and the core self. It symbolizes one's conscious identity, ego, and willpower."
                case .moon: return "The Moon symbolizes emotions, instincts, and the subconscious. It represents feelings, intuition, and the nurturing side of us."
                case .mercury: return "Mercury signifies communication, intellect, and adaptability. It influences how we express ourselves, think, and learn."
                case .venus: return "Venus represents love, beauty, and harmony. It influences relationships, aesthetics, and our appreciation of beauty."
                case .mars: return "Mars symbolizes energy, passion, and assertiveness. It drives ambition, desire, and how we assert ourselves."
                case .jupiter: return "Jupiter signifies expansion, growth, and opportunity. It brings luck, abundance, and a philosophical outlook."
                case .saturn: return "Saturn represents discipline, responsibility, and challenges. It brings structure, lessons, and tests our endurance."
                case .uranus: return "Uranus symbolizes innovation, change, and disruption. It brings sudden shifts, innovation, and rebellion."
                case .neptune: return "Neptune represents dreams, illusions, and spirituality. It inspires creativity, imagination, and higher ideals."
                case .pluto: return "Pluto signifies transformation, power, and regeneration. It represents deep change, hidden power, and rebirth."
                case .ascendant: return "The Ascendant marks the beginning, the persona, and the outer self. It represents how others see us and our first impressions."
                case .decendant: return "The Descendant represents relationships, partnerships, and others. It indicates our approach to others and our needs in relationships."
                case .midheaven: return "The Midheaven signifies career, ambitions, and public image. It represents our aspirations, achievements, and reputation."
                case .imumCoeli: return "The Imum Coeli symbolizes roots, home, and private life. It represents our family, heritage, and emotional foundation."
                case .lunarAscendingNode: return "The Lunar Ascending Node signifies growth, connections, and karma. It indicates our life's path, connections, and karmic lessons."
                case .lunarDecendingNode: return "The Lunar Descending Node represents release, closure, and letting go. It indicates what we need to release and learn from in this lifetime."
                case .lunarApogee: return "The Lunar Apogee marks the point farthest from the Earth in the Moon's orbit. It influences emotional extremes and intensity."
                case .lunarPerigee: return "The Lunar Perigee marks the point nearest to the Earth in the Moon's orbit. It influences heightened emotions and sensitivity."
                case .partOfFortune: return "The Part of Fortune signifies harmony, success, and well-being. It represents the area of life where we find joy and fulfillment."
                case .partOfSpirit: return "The Part of Spirit represents inner strength, wisdom, and resilience. It indicates our ability to overcome challenges and find purpose."
                case .partOfEros: return "The Part of Eros signifies passionate connections and desires. It represents our erotic nature, desires, and intense attractions."
                }
            }
            
            // Long Description
            var longDescription: String {
                switch self {
                case .sun: return "The Sun represents vitality, ego, and the core self. It embodies one's drive, ambitions, and life force, illuminating the path toward self-discovery and expression. It signifies the essence of identity, guiding individuality and purpose."
                case .moon: return "The Moon symbolizes emotions, instincts, and the subconscious. It reflects our inner self, nurturing qualities, and intuitive nature. It guides our emotional responses and unveils the depths of our desires, fostering a sense of comfort and familiarity."
                case .mercury: return "Mercury signifies communication, intellect, and adaptability. It governs thought processes, intellectual pursuits, and the exchange of ideas. Mercury encourages flexibility, sharp wit, and the art of expression, influencing how we perceive and convey information."
                case .venus: return "Venus represents love, beauty, and harmony. It embodies our affections, aesthetic sensibilities, and relationships. Venus governs pleasures, attracting and nurturing bonds while fostering an appreciation for art, beauty, and romantic connections."
                case .mars: return "Mars symbolizes energy, passion, and assertiveness. It embodies our drive for action, determination, and physical vitality. Mars inspires courage, fuels desires, and influences our ability to pursue goals with vigor and resilience."
                case .jupiter: return "Jupiter signifies expansion, growth, and opportunity. It represents abundance, wisdom, and the pursuit of higher knowledge. Jupiter encourages optimism, broadening horizons, and fostering a sense of purposeful exploration."
                case .saturn: return "Saturn represents discipline, responsibility, and challenges. It embodies structure, limitations, and the pursuit of long-term goals. Saturn teaches invaluable lessons through trials, fostering resilience, and promoting accountability."
                case .uranus: return "Uranus symbolizes innovation, change, and disruption. It governs unconventional thinking, originality, and sudden shifts. Uranus sparks revolutions, encourages independence, and inspires breakthroughs in technology and ideologies."
                case .neptune: return "Neptune represents dreams, illusions, and spirituality. It embodies imagination, intuition, and the subconscious realms. Neptune blurs boundaries, evoking compassion, creativity, and a deep connection to the mystical and divine."
                case .pluto: return "Pluto signifies transformation, power, and regeneration. It governs profound changes, inner evolution, and rebirth. Pluto unearths hidden truths, facilitating growth through the process of letting go and embracing renewal."
                case .ascendant: return "The Ascendant marks the beginning, the persona, and the outer self. It represents the lens through which the world perceives us and influences our initial impressions. The Ascendant shapes our approach to life and impacts how others perceive our identity."
                case .decendant: return "The Descendant represents relationships, partnerships, and others. It embodies collaboration, balance, and the quest for companionship. The Descendant guides the qualities we seek in others and influences our approach to forming meaningful connections."
                case .midheaven: return "The Midheaven signifies career, ambitions, and public image. It embodies aspirations, achievements, and one's place in the world. The Midheaven guides our professional pursuits and shapes how we are perceived in the public sphere."
                case .imumCoeli: return "The Imum Coeli symbolizes roots, home, and private life. It represents our emotional foundation, ancestry, and sense of security. The Imum Coeli influences our connection to family, heritage, and the nurturing aspects of our lives."
                case .lunarAscendingNode: return "The Lunar Ascending Node signifies growth, connections, and karma. It represents significant encounters, destiny, and the lessons we are meant to learn. The Lunar Ascending Node guides us toward personal evolution and meaningful relationships."
                case .lunarDecendingNode: return "The Lunar Descending Node represents release, closure, and letting go. It embodies endings, karmic debts, and the culmination of experiences. The Lunar Descending Node encourages us to relinquish what no longer serves our growth."
                case .lunarApogee: return "The Lunar Apogee marks the point farthest from the Earth in the Moon's orbit. It signifies a heightened emotional sensitivity and an inward-focused energy. The Lunar Apogee influences periods of introspection and spiritual exploration."
                case .lunarPerigee: return "The Lunar Perigee marks the point nearest to the Earth in the Moon's orbit. It embodies intensified emotions and a stronger connection to the external world. The Lunar Perigee may heighten intuitive abilities and emotional responsiveness."
                case .partOfFortune: return "The Part of Fortune signifies harmony, success, and well-being. It embodies blessings, prosperity, and the alignment of destiny. The Part of Fortune guides us toward experiences that foster joy, fulfillment, and a sense of abundance."
                case .partOfSpirit: return "The Part of Spirit represents inner strength, wisdom, and resilience. It embodies the essence of the soul's journey, spiritual growth, and enlightenment. The Part of Spirit encourages us to embrace challenges as opportunities for growth."
                case .partOfEros: return "The Part of Eros signifies passionate connections and desires. It embodies eroticism, romantic inclinations, and the pursuit of intimacy. The Part of Eros guides us toward fulfilling relationships that ignite passion and deep emotional bonds."
                }
            }
            
            var subtitle: String {
                switch self {
                case .sun: return "The Center of the Solar System"
                case .moon: return "Earth's Natural Satellite"
                case .mercury: return "The Swift Messenger"
                case .venus: return "The Evening Star"
                case .mars: return "The Red Planet"
                case .jupiter: return "The Giant of the Solar System"
                case .saturn: return "The Ringed Planet"
                case .uranus: return "The Sideways Planet"
                case .neptune: return "The Mystic Planet"
                case .pluto: return "The Dwarf Planet"
                case .ascendant: return "The Mask You Present to the World"
                case .decendant: return "The Mirror to Your Ascendant"
                case .midheaven: return "Your Public Persona"
                case .imumCoeli: return "Your Roots and Foundations"
                case .lunarAscendingNode: return "Your Path Towards Growth"
                case .lunarDecendingNode: return "What You Leave Behind"
                case .lunarApogee: return "The Farthest Point of the Moon's Orbit"
                case .lunarPerigee: return "The Closest Point of the Moon's Orbit"
                case .partOfFortune: return "Harmony and Prosperity"
                case .partOfSpirit: return "Your Inner Essence"
                case .partOfEros: return "Passion and Desire"
                }
            }
            
            var attributesCombined: String {
                let allAttributes = attributes.joined(separator: ", ")
                return "Attributes: \(allAttributes)"
            }
            var attributes: [String] {
                switch self {
                case .sun: return ["Vitality", "Leadership", "Confidence"]
                case .moon: return ["Emotions", "Intuition", "Nurturing"]
                case .mercury: return ["Communication", "Curiosity", "Adaptability"]
                case .venus: return ["Love", "Harmony", "Creativity"]
                case .mars: return ["Action", "Courage", "Passion"]
                case .jupiter: return ["Expansion", "Opportunity", "Abundance"]
                case .saturn: return ["Discipline", "Responsibility", "Structure"]
                case .uranus: return ["Innovation", "Originality", "Independence"]
                case .neptune: return ["Imagination", "Sensitivity", "Spirituality"]
                case .pluto: return ["Transformation", "Power", "Rebirth"]
                case .ascendant: return ["First impressions", "Outward demeanor", "Appearance"]
                case .decendant: return ["Partnerships", "Relationships", "Collaboration"]
                case .midheaven: return ["Career", "Public image", "Ambition"]
                case .imumCoeli: return ["Roots", "Family", "Heritage"]
                case .lunarAscendingNode: return ["Growth", "Learning", "Evolution"]
                case .lunarDecendingNode: return ["Release", "Letting go", "Karmic tendencies"]
                case .lunarApogee: return ["Farthest point of emotional expression"]
                case .lunarPerigee: return ["Closest point of emotional expression"]
                case .partOfFortune: return ["Harmony", "Prosperity", "Happiness"]
                case .partOfSpirit: return ["Inner essence", "Soul", "Core values"]
                case .partOfEros: return ["Passion", "Desire", "Intimacy"]
                }
            }
            
            public var hasGravity:Bool {
                switch self {
                case .moon, .sun, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune: return true
                default: return false
                }
            }
            
            public static var bodiesWithGravity:[AspectBody.NodeType] = [.moon,
                                                                         .sun,
                                                                         .mercury,
                                                                         .venus,
                                                                         .mars,
                                                                         .jupiter,
                                                                         .saturn,
                                                                         .uranus,
                                                                         .neptune]
            
            public func planet(starChart: StarChart, highPrecision:Bool = true) -> Planet? {
                let julianDay = JulianDay(starChart.date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
                
            }
            
            public func planet(date:Date, highPrecision:Bool = true) -> Planet? {
                let julianDay = JulianDay(date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
                
            }
            
            public func planetaryOrbit(date:Date, highPrecision:Bool = true) -> PlanetaryOrbits? {
                let julianDay = JulianDay(date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
                
            }
            
            public func equatorialCoordinates(date:Date, highPrecision:Bool = true) -> EquatorialCoordinates? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
                default: return nil
                }
            }
            
            public func ascendingNode(planetaryOrbit: PlanetaryOrbits) -> Degree {
                return planetaryOrbit.longitudeOfAscendingNode()
            }
            
            public func rise(date:Date, highPrecision:Bool = true) -> Degree? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Earth(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).longitudeOfTrueAscendingNode
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                default: return nil
                }
            }
            
            public func exaltation(date:Date, highPrecision:Bool = true) -> Degree? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Earth(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).longitudeOfMeanPerigee
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                default: return nil
                }
            }
            
            public func geocentricLongitude(date:Date, coords:GeographicCoordinates = GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0), highPrecision:Bool = true) -> Degree? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).meanLongitude()//.apparentGeocentricEquatorialCoordinates.alpha.inDegrees
                case .lunarApogee: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).apogee(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .lunarPerigee: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).perigee(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .lunarAscendingNode: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).passageThroughAscendingNode(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .lunarDecendingNode: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).passageThroughDescendingNode(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
                case .ascendant: return Earth(julianDay: julianDay, highPrecision: highPrecision).getASC(coords: coords)
                case .decendant: return Earth(julianDay: julianDay, highPrecision: highPrecision).getCelestialLongitudeOfHouseCusp(house: .seventh, coords: coords)
                case .midheaven: return Earth(julianDay: julianDay, highPrecision: highPrecision).getMidHeaven(coords: coords)
                case .imumCoeli: return Earth(julianDay: julianDay, highPrecision: highPrecision).getCelestialLongitudeOfHouseCusp(house: .forth, coords: coords)
                case .partOfFortune: return Earth(julianDay: julianDay, highPrecision: highPrecision).getPartOfFortune(coords: coords)
                case .partOfSpirit: return Earth(julianDay: julianDay, highPrecision: highPrecision).getPartOfSpirit(coords: coords)
                case .partOfEros: return Earth(julianDay: julianDay, highPrecision: highPrecision).getPartOfEros(coords: coords)
                }
            }
            
            public func distanceFromEarth(date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision).radiusVector
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).radiusVector
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
                default: return nil
                }
            }
            
            public func massOfPlanet() -> Kilogram? {
                switch self {
                case .sun: return 1.9885e30
                case .moon: return 7.342e22
                case .mercury: return 3.3011e23
                case .venus: return 4.8675e24
                case .mars: return 6.4171e23
                case .jupiter: return 1.8982e27
                case .saturn: return 5.6834e26
                case .uranus: return 8.6810e25
                case .neptune: return 1.02413e26
                case .pluto: return 1.303e22
                default: return nil
                }
            }
            
            
            public func planetaryDetails(date:Date, highPrecision:Bool = true) -> PlanetaryDetails? {
                let julianDay = JulianDay(date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
            }
            
            public func celestialBody(date:Date, highPrecision:Bool = true) -> CelestialBody? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision)
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision)
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
            }
            
            public func radiusVector(date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
                return self.planetaryDetails(date: date, highPrecision: highPrecision)?.radiusVector ?? self.celestialBody(date: date, highPrecision: highPrecision)?.radiusVector
            }
            
            // Distance between This Planet and Another Planet
            public func distance(from otherPlanet:NodeType, date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
                
                guard let planet1 = self.planet(date: date) else {return nil}
                guard let planet2 = otherPlanet.planet(date: date) else {return nil}
                
                /// Guard for Radius Vectors (required for trig)
                guard let a:Double = self.radiusVector(date: date, highPrecision: highPrecision)?.value,
                      let b:Double = otherPlanet.radiusVector(date: date, highPrecision: highPrecision)?.value else {
                    return nil
                }
                
                /// Catch for Basic Values
                switch self {
                case .sun:
                    switch otherPlanet {
                    case .sun: return 0
                    default: return AstronomicalUnit(b)
                    }
                default:
                    switch otherPlanet {
                    case .sun: return AstronomicalUnit(a)
                    default: ()
                    }
                }
                
                /// Trig Values (distances and angles)
                let p1_HeliocentricAngle = planet1.heliocentricEclipticCoordinates.celestialLongitude.value //self.heliocentricPosition().value
                let p2_HeliocentricAngle = planet2.heliocentricEclipticCoordinates.celestialLongitude.value //otherPlanet.heliocentricPosition().value
                
                /// Trig (Trigonometry) 📐
                var C:Double = Double(p2_HeliocentricAngle - p1_HeliocentricAngle)
                C = (C + 180).truncatingRemainder(dividingBy: 360) - 180
                let c:Double = sqrt(((a*a)+(b*b))-(2*a*b*cos(C)))
                
                /// Distance between the two Planets
                return AstronomicalUnit(c)
            }
            
            public func gravimetricForceBetween(otherPlanet:NodeType, date: Date) -> Newtons? {
                guard let p1mass = massOfPlanet(),
                      let p2mass = otherPlanet.massOfPlanet(),
                      let distanceInMeters = self.distance(from: otherPlanet, date: date)?.value else {
                    return nil
                }
                let universalGravityConstant:Double = 6.673e-11
                return Newtons((universalGravityConstant*p1mass*p2mass)/(distanceInMeters*distanceInMeters))
            }
            
            public func gravimetricForceOnSun(date:Date) -> Newtons? {
                return gravimetricForceBetween(otherPlanet: .sun, date: date)
            }
            
            public func gravimetricForceOnEarth(date:Date) -> Newtons? {
                guard let mass = massOfPlanet(),
                      let distanceInMeters = distanceFromEarth(date: date)?.inMeters.value else {
                    return nil
                }
                let earthMass:Kilogram = 5.97237e24
                let universalGravityConstant:Double = 6.673e-11
                return Newtons((universalGravityConstant*earthMass*mass)/(distanceInMeters*distanceInMeters))
            }
            
            public func gravimetricForce(on geographicCoordinate:GeographicCoordinates, date:Date) -> Newtons? {
                guard let mass = massOfPlanet(),
                      let distanceInMeters = distanceFromEarth(date: date)?.inMeters.value else {
                    return nil
                }
                let earthMass:Kilogram = 5.97237e24
                let universalGravityConstant:Double = 6.673e-11
                return Newtons((universalGravityConstant*earthMass*mass)/(distanceInMeters*distanceInMeters))
            }
            
            public func geocentricNormalVector(date:Date) -> Vector3 {
                guard let coords = equatorialCoordinates(date: date) else { return Vector3.empty }
                
                let phi   = (90.0-coords.alpha.inDegrees.value)*(Double.pi/180);
                let theta = (coords.delta.value+180.0)*(Double.pi/180);
                
                let x = (sin(phi)*cos(theta));
                let z = (sin(phi)*sin(theta));
                let y = (cos(phi));
                
                return Vector3(x,y,z)
            }
            
            public func heliocentricNormalVector(date:Date) -> Vector3 {
                guard let coords = equatorialCoordinates(date: date) else { return Vector3.empty }
                
                let phi   = (90.0-coords.alpha.inDegrees.value)*(Double.pi/180);
                let theta = (coords.delta.value+180.0)*(Double.pi/180);
                
                let x = (sin(phi)*cos(theta));
                let z = (sin(phi)*sin(theta));
                let y = (cos(phi));
                
                return Vector3(x,y,z)
            }
            
            public func geocentricGravimetricTensor(date:Date) -> GravimetricTensor {
                guard let magnitude = gravimetricForceOnEarth(date: date) else { return .empty }
                let vectorNormal = geocentricNormalVector(date: date)
                return GravimetricTensor(vectorNormal: vectorNormal, magnitude: magnitude.value)
            }
            
            public func heliocentricGravimetricTensor(date:Date) -> GravimetricTensor {
                guard let magnitude = gravimetricForceOnEarth(date: date) else { return .empty }
                let vectorNormal = heliocentricNormalVector(date: date)
                return GravimetricTensor(vectorNormal: vectorNormal, magnitude: magnitude.value)
            }
        }
    }
}
