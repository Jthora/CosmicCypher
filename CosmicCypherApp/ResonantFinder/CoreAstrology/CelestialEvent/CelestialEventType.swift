//
//  CelestialEventType.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import UIKit

// MARK: Celestial Event
extension CoreAstrology {
    // Celestial Event
    enum CelestialEventType: Hashable {
        case retrograde(_ type: RetrogradeEvent.RetrogradeType)
        case transit(_ type: TransitEvent.TransitType)
        case aspect(_ type: AspectEventType)
        case formation(_ type: FormationEvent.FormationType)
        case octive(_ type: OctiveEvent.OctiveType)
        case resonance(_ type:ResonanceEventType)
        
        static func systemImage(_ type:CelestialEventType) -> UIImage {
            return type.systemImage
        }
        var systemImage:UIImage {
            switch self {
            case .aspect(_): return UIImage(systemName: "point.3.connected.trianglepath.dotted")!
            case .retrograde(_): return UIImage(systemName: "scribble")!
            case .transit(_): return UIImage(systemName: "rectangle.trailinghalf.inset.filled.arrow.trailing")!
            case .formation(_): return UIImage(systemName: "star")!
            case .octive(_): return UIImage(systemName: "lines.measurement.horizontal")!
            case .resonance(_): return UIImage(systemName: "waveform.path")!
            }
        }
        
        static func menuItemTitle(_ type:CelestialEventType) -> String {
            return type.menuItemTitle
        }
        var menuItemTitle:String {
            switch self {
            case .retrograde(_): return "Retrogrades"
            case .transit(_): return "Transits"
            case .aspect(_): return "Aspects"
            case .formation(_): return "Formations"
            case .octive(_): return "Octives"
            case .resonance(_): return "Resonance"
            }
        }
        
        func menuItemAction(isOn:Bool, handler: (()->Void)? = nil ) -> UIAction {
            let state = isOn ? UIMenuElement.State.on : UIMenuElement.State.off
            let action = UIAction(title: self.menuItemTitle, image: self.systemImage, state: state) { action in
                // Action Block
                handler?()
            }
            return action
        }
        
        static func == (lhs: CoreAstrology.CelestialEventType, rhs: CoreAstrology.CelestialEventType) -> Bool {
            return lhs.hashNumber == rhs.hashNumber
        }
         
        var hashNumber: Int {
            switch self {
            case .retrograde(let type): return 0x0000 | type.hashValue
            case .transit(let type): return 0x1000 | type.hashValue
            case .aspect(let type): return 0x2000 | type.hashValue
            case .formation(let type): return 0x3000 | type.hashValue
            case .octive(let type): return 0x4000 | type.hashValue
            case .resonance(let type): return 0x5000 | type.hashValue
            }
        }
    }
}
