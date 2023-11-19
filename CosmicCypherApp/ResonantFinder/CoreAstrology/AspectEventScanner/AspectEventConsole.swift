//
//  AspectEventConsole.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/29/23.
//

import Foundation
import SwiftAA

protocol AspectEventConsoleDelegate {
    func consoleUpdated(text:String)
}

class AspectEventConsole {
    var delegate:AspectEventConsoleDelegate? = nil
    weak var scanner:AspectEventScanner? = nil
    
    var text:String = "🟢 Ready" {
        didSet {
            delegate?.consoleUpdated(text: text)
        }
    }
    
    init(delegate: AspectEventConsoleDelegate? = nil) {
        self.delegate = delegate
    }
    
    func update() {
        let currentText = text
        text = currentText
    }
    
    func updated(startDate:Date) {
        let currentText = text
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateText = dateFormatter.string(from: startDate)
        text = "📆 Start Date Updated: [\(dateText)]\n\(currentText)"
    }
    
    func updated(endDate:Date) {
        let currentText = text
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateText = dateFormatter.string(from: endDate)
        text = "📆 End Date Updated: [\(dateText)]\n\(currentText)"
    }
    
    func updated(longitude:Double) {
        let currentText = text
        let longitudeText = String(format: "%.2f", longitude)
        text = "🧭 Longitude Updated: [\(longitudeText)]\n\(currentText)"
    }
    
    func updated(latitude:Double) {
        let currentText = text
        let latitudeText = String(format: "%.2f", latitude)
        text = "🧭 Latitude Updated: [\(latitudeText)]\n\(currentText)"
    }
    
    func updated(coordinates:GeographicCoordinates) {
        let currentText = text
        let longitudeText = String(format: "%.2f", coordinates.longitude.value)
        let latitudeText = String(format: "%.2f", coordinates.latitude.value)
        text = "🗺️ Coordinates Updated: [\(longitudeText),\(latitudeText)]\n\(currentText)"
    }
    
    func updated(sampleMode:AspectEventScanner.SampleMode) {
        let currentText = text
        text = "🔹 Sample Mode: [\(sampleMode.consoleText)]\n\(currentText)"
    }
    
    func updated(state:AspectEventScanner.State) {
        let currentText = text
        text = "\(state.consoleText)\n\(currentText)"
    }
    
    func updatedPlanetsAndNodes() {
        let currentText = text
        text = "🪐 Planets & Nodes Updated\n\(currentText)"
    }
    
    func updatedAspectAngles() {
        let currentText = text
        text = "📐 Aspect Angles Updated\n\(currentText)"
    }
    
    func scanning(scans:Int, scrying:Int, discovered:Int) {
        text = "🌐 Scans: [\(scans)]\n🔮 Scrying: [\(scrying)]\n☑️ Discovered: [\(discovered)]]"
    }
    
    func detailedScanning(scans:Int, scrying:Int, discovered:Int, currentDate:Date) {
        text = "🌐 Scans: [\(scans)]\n🔮 Scrying: [\(scrying)]\n☑️ Discovered: [\(discovered)]]"
    }
    
    func error(_ errorType:ErrorType, context:String? = nil) {
        let currentText = text
        let contextString = context == nil ? "" : ": \(context!)"
        text = "\(errorType.preText)\(contextString)\n\(currentText)"
    }
}

extension AspectEventConsole {
    enum ErrorType: Error {
        case system
        case scanner
        case export
        
        var preText:String {
            switch self {
            case .system: return "🚨 System Error"
            case .scanner: return "🛑 Scanner Error"
            case .export: return "⛔️ Export Error"
            }
        }
    }
}
