//
//  CelestialEventScanner+Core.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import Foundation
import SwiftAA

extension CelestialEventScanner {
    class Core {
        
        static var scanner:CelestialEventScanner = {
            let s = CelestialEventScanner()
            s.console = console
            s.exporter = exporter
            s.archive = archive
            console.scanner = s
            exporter.scanner = s
            exporter.archive = archive
            return s
        }()
        static var console:CelestialEventConsole = CelestialEventConsole()
        static var exporter:CelestialEventExporter = CelestialEventExporter()
        static var archive:CelestialEventDataArchive = CelestialEventDataArchive()
        
        static var hashKey: CelestialEventScanner.Results.HashKey {
            return exporter.currentExportableData.hashKey
        }
        
        static var exportableData: CelestialEventExporter.ExportableData {
            return exporter.currentExportableData
        }
        
        static var state: CelestialEventScanner.State {
            get {
                return scanner.state
            }
            set {
                scanner.state = newValue
            }
        }
        
        static var startDate: Date {
            get {
                return scanner.startDate
            }
            set {
                scanner.startDate = newValue
            }
        }
        
        static var endDate: Date {
            get {
                return scanner.endDate
            }
            set {
                scanner.endDate = newValue
            }
        }
        
        static var coordinates: GeographicCoordinates {
            get {
                return scanner.coordinates
            }
            set {
                scanner.coordinates = newValue
            }
        }
        
        static var planetsAndNodes:[CoreAstrology.AspectBody.NodeType] {
            get {
                return scanner.selectedNodeTypes
            }
            set {
                scanner.selectedNodeTypes = newValue
            }
        }
        
        static var aspectAngles:[CoreAstrology.AspectRelationType] {
            get {
                return scanner.selectedAspects
            }
            set {
                scanner.selectedAspects = newValue
            }
        }
        
        static var scannerDelegate:CelestialEventScannerDelegate? {
            get {
                return scanner.delegate
            }
            set {
                scanner.delegate = newValue
            }
        }
        
        static var consoleDelegate:CelestialEventConsoleDelegate? {
            get {
                return console.delegate
            }
            set {
                console.delegate = newValue
            }
        }
        
        static var retrogradeScanEnabled:Bool {
            get { return scanner.useRetrogradeScanner }
            set { scanner.useRetrogradeScanner = newValue }
        }
        
        static var formationScanEnabled:Bool {
            get { return scanner.useFormationScanner }
            set { scanner.useFormationScanner = newValue }
        }
        
        static var transitScanEnabled:Bool {
            get { return scanner.useTransitScanner }
            set { scanner.useTransitScanner = newValue }
        }
        
        static var aspectScanEnabled:Bool {
            get { return scanner.useAspectScanner }
            set { scanner.useFormationScanner = newValue }
        }
        
        static var octiveScanEnabled:Bool {
            get { return scanner.useOctiveScanner }
            set { scanner.useOctiveScanner = newValue }
        }
        
        static var resonanceScanEnabled:Bool {
            get { return scanner.useResonanceScanner }
            set { scanner.useResonanceScanner = newValue }
        }
        
        static func scan() {
            scanner.scan()
        }
    }
}
