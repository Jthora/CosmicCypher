//
//  AspectEventScannerCore.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import Foundation
import SwiftAA

extension AspectEventScanner {
    class Core {
        
        static var scanner:AspectEventScanner = {
            let s = AspectEventScanner()
            s.console = console
            s.exporter = exporter
            s.archive = archive
            console.scanner = s
            exporter.scanner = s
            exporter.archive = archive
            return s
        }()
        static var console:AspectEventConsole = AspectEventConsole()
        static var exporter:AspectEventExporter = AspectEventExporter()
        static var archive:AspectEventDataArchive = AspectEventDataArchive()
        
        static var hashKey: AspectEventScanner.Results.HashKey {
            return exporter.currentExportableData.hashKey
        }
        
        static var exportableData: AspectEventExporter.ExportableData {
            return exporter.currentExportableData
        }
        
        static var state: AspectEventScanner.State {
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
        
        static var scannerDelegate:AspectEventScannerDelegate? {
            get {
                return scanner.delegate
            }
            set {
                scanner.delegate = newValue
            }
        }
        
        static var consoleDelegate:AspectEventConsoleDelegate? {
            get {
                return console.delegate
            }
            set {
                console.delegate = newValue
            }
        }
        
        static func scan() {
            scanner.scan()
        }
    }
}
