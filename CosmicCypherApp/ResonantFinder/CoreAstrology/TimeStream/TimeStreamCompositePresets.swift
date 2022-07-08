//
//  TimeStreamCompositePresets.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/5/22.
//

import Foundation

enum TimeStreamCompositePresetOption: Int, CaseIterable {
    case all
    case sun
    case moon
    case asc
    case mc
    case spirit
    case fortune
    case prime
    case bodies
    case planets
    case sex
    case love
    case work
    case mentorship
    case lunar
    case era
    case evil
    case dangerZone
    case cheatcodes
    
    var name:String {
        switch self {
            case .all: return "All"
            case .sun: return "Sun"
            case .moon: return "Moon"
            case .asc: return "ASC"
            case .mc: return "MC"
            case .spirit: return "Spirit"
            case .fortune: return "Fortune"
            case .prime: return "Prime Three"
            case .bodies: return "Astrological Bodies"
            case .planets: return "Planets"
            case .sex: return "Sex"
            case .love: return "Love"
            case .work: return "Work"
            case .mentorship: return "Mentorship"
            case .lunar: return "Lunar"
            case .era: return "Era"
            case .evil: return "Evil"
            case .dangerZone: return "Danger Zone"
            case .cheatcodes: return "Cheatcodes"
        }
    }
    
    var types:[CoreAstrology.AspectBody.NodeType] {
        
        switch self {
        case .all: return DEFAULT_SELECTED_NODETYPES
        case .sun: return [.sun]
        case .moon: return [.moon]
        case .asc: return [.ascendant]
        case .mc: return [.midheaven]
        case .spirit: return [.partOfSpirit]
        case .fortune: return [.partOfFortune]
        case .prime: return [.sun, .moon, .ascendant]
        case .lunar: return [.lunarAscendingNode, .lunarApogee, .moon]
        case .bodies: return [.sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune]
        case .planets: return [.mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune]
        case .sex: return [.venus, .mars, .mercury, .partOfEros]
        case .love: return [.venus, .mars, .mercury, .sun, .moon, .ascendant]
        case .work: return [.mercury, .mars, .sun, .saturn, .midheaven]
        case .mentorship: return [.lunarAscendingNode, .moon, .sun, .ascendant, .jupiter]
        case .era: return [.jupiter, .saturn, .uranus, .neptune]
        case .evil: return [.venus, .jupiter, .mars, .saturn]
        case .dangerZone: return [.lunarDecendingNode, .lunarPerigee, .decendant, .imumCoeli]
        case .cheatcodes: return [.lunarAscendingNode, .partOfFortune]
        }
        
    }
}
