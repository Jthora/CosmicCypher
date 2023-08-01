//
//  AspectEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import Foundation
import SwiftAA

protocol AspectEventScannerDelegate {
    func scanUpdate(progress:Float, subProgress:Float)
    func scanError(error:AspectEventScanner.ScanError)
    func scanComplete(aspectsFound:[Date: [CoreAstrology.Aspect]])
}

class AspectEventScanner {
    
    // State
    private var _state:State = .ready
    var state:State {
        get {
            return _state
        }
        set {
            _state = newValue
//            DispatchQueue.main.async {
//                self.console?.updated(state: newValue)
//            }
        }
    }
    
    // Mode
    var mode:SampleMode = .simple {
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(sampleMode: self.mode)
            }
        }
    }
    
    // Delegate
    var delegate:AspectEventScannerDelegate? = nil
    weak var console:AspectEventConsole? = nil
    weak var exporter:AspectEventExporter? = nil
    weak var archive:AspectEventDataArchive? = nil
    
    // Time
    lazy var startDate: Date = StarChart.Core.current.date {
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(startDate: self.startDate)
            }
        }
    }
    lazy var currentDate: Date = StarChart.Core.current.date{
        didSet {
            //console?.updatedDates()
        }
    }
    lazy var endDate: Date = StarChart.Core.current.date{
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(endDate: self.endDate)
            }
        }
    }
    
    // Space
    private lazy var _coordinates: GeographicCoordinates = StarChart.Core.current.coordinates
    var coordinates: GeographicCoordinates {
        get {
            return _coordinates
        }
        set {
            _coordinates = newValue
            console?.updated(coordinates: _coordinates)
        }
    }
    var longitude: Double {
        get {
            _coordinates.longitude.value
        }
        set {
            let newCoordinates = GeographicCoordinates(positivelyWestwardLongitude: Degree(newValue), latitude: _coordinates.latitude)
            _coordinates = newCoordinates
            console?.updated(longitude: newValue)
        }
    }
    var latitude: Double {
        get {
            _coordinates.latitude.value
        }
        set {
            let newCoordinates = GeographicCoordinates(positivelyWestwardLongitude: _coordinates.latitude, latitude: Degree(newValue))
            _coordinates = newCoordinates
            console?.updated(latitude: newValue)
        }
    }
    
    // Planets & Nodes
    private lazy var _selectedNodeTypes:[CoreAstrology.AspectBody.NodeType] = StarChart.Core.selectedNodeTypes
    var selectedNodeTypes:[CoreAstrology.AspectBody.NodeType] {
        get {
            return _selectedNodeTypes
        }
        set {
            _selectedNodeTypes = newValue
            //console?.updatedPlanetsAndNodes()
        }
    }
    
    // Aspect Angles
    private lazy var _selectedAspects: [CoreAstrology.AspectRelationType]  = StarChart.Core.selectedAspects
    var selectedAspects:[CoreAstrology.AspectRelationType] {
        get {
            return _selectedAspects
        }
        set {
            _selectedAspects = newValue
            //console?.updatedAspectAngles()
        }
    }
    
    var activelyScanningAspects:[CoreAstrology.Aspect.SymbolHash: (CoreAstrology.Aspect, Date)] = [:]
    var recentlyLockedInAspects:[CoreAstrology.Aspect.SymbolHash:Bool] = [:]
    
    var lockedInAspects: [Date: [CoreAstrology.Aspect]] = [:]
    func lockIn(aspect: CoreAstrology.Aspect, for date:Date) {
        var aspectArray:[CoreAstrology.Aspect] = lockedInAspects[date] ?? []
        aspectArray.append(aspect)
        lockedInAspects[date] = aspectArray
    }
    
    
    func findAspectEvents() {
        state = .scanning
        guard startDate != endDate else {
            state = .fail
            console?.error(.scanner, context: "Start Date == End Date")
            delegate?.scanError(error: .startAndEndDateAreSame)
            state = .ready
            return
        }
        
        var scanCount:Float = 0
        guard let totalScanCount:Float = daysBetweenDates(startDate: startDate, endDate: endDate) else {
            state = .fail
            console?.error(.scanner, context: "Cannot get Total Scan Count from Dates")
            delegate?.scanError(error: .cannotGetTotalScanCountFromDates)
            state = .ready
            return
        }
        
        // Scanning Properties
        var currentDate = startDate
        
        // Calculation Delta
        let startTime = Date().timeIntervalSince1970
        var calculationDelta:TimeInterval = 0
        
        // Background Thread
        DispatchQueue.global().async {
            
            // Scanning Loop
            while currentDate <= self.endDate {
                
                // Number of Iterations
                scanCount += 1
                let progress = scanCount/totalScanCount
                
                let preStarChartCalculationTimeStamp = Date().timeIntervalSince1970
                
                // Calculate the positions of the planets for the current Date
                let starChart = StarChartRegistry.main.getStarChart(date: currentDate, geographicCoordinates: self.coordinates)
                
                let postStarChartCalculationTimeStamp = Date().timeIntervalSince1970
                calculationDelta = postStarChartCalculationTimeStamp - preStarChartCalculationTimeStamp
                
                
                // Prevents Rescry into any recently discovered aspects
                var aspectsStillRecentlyLockedIn:[CoreAstrology.Aspect.SymbolHash] = []
                
                // Report progress to Console UI
                self.console?.scanning(scans: Int(scanCount),
                                       scrying: self.activelyScanningAspects.count,
                                       discovered: self.lockedInAspects.count,
                                       calculationDelta: calculationDelta)
                
                // Report to View Controller for updating Progress Bars
                self.delegate?.scanUpdate(progress: progress, subProgress: 0)
                
                // The Aspects for this date are calculated
                for thisAspect in starChart.aspects {
                    
                    // Only perform the scry for selected aspects, planets and nodes
                    guard self.selectedAspects.contains(thisAspect.relation.type), self.selectedNodeTypes.contains(thisAspect.primaryBody.type), self.selectedNodeTypes.contains(thisAspect.secondaryBody.type) else {continue}
                    
                    // Skip any recently locked in aspects
                    guard self.recentlyLockedInAspects[thisAspect.symbolHash] == nil else {
                        continue
                    }
                    
                    if let (previousAspect, previousDate) = self.activelyScanningAspects[thisAspect.symbolHash] {
                        // Aspect is not new
                        let previousOrb = previousAspect.relation.orbDistance
                        let thisOrb = thisAspect.relation.orbDistance
                        if abs(thisOrb) < abs(previousOrb) {
                            // This aspect is closer
                            self.activelyScanningAspects[thisAspect.symbolHash] = (thisAspect, currentDate)
                        } else {
                            // The aspect is not closer, the previous aspect is correct
                            self.activelyScanningAspects[thisAspect.symbolHash] = nil
                            self.lockIn(aspect: thisAspect, for: currentDate)
                            self.recentlyLockedInAspects[thisAspect.symbolHash] = true
                        }
                    } else {
                        // Aspect is new
                        self.activelyScanningAspects[thisAspect.symbolHash] = (thisAspect, currentDate)
                    }
                    
                }
                
                // remove recentlyLockedInAspects that are no longer being detected
                let symbolHashes = starChart.aspects.map { $0.symbolHash }
                let recentlyLocked = self.recentlyLockedInAspects
                for (key, _) in recentlyLocked {
                    if !symbolHashes.contains(key) {
                        self.recentlyLockedInAspects.removeValue(forKey: key)
                    }
                }
                
                // Scan to check if the current aspects
             
                // determine the next scan date (based on mode selection)
                switch self.mode {
                case .simple:
                    let calendar = Calendar.current
                    var dateComponents = DateComponents()
                    dateComponents.day = 1
                    guard let nextDay = calendar.date(byAdding: dateComponents, to: currentDate) else {
                        DispatchQueue.main.async {
                            self.console?.error(.system, context: "Date Component Creation Failure")
                        }
                        return
                    }
                    currentDate = nextDay
                case .precise:
                    let calendar = Calendar.current
                    var dateComponents = DateComponents()
                    dateComponents.day = 1
                    let nextDay = calendar.date(byAdding: dateComponents, to: currentDate)
                    guard let nextDay = calendar.date(byAdding: dateComponents, to: currentDate) else {
                        DispatchQueue.main.async {
                            self.console?.error(.system, context: "Date Component Creation Failure")
                        }
                        return
                    }
                    currentDate = nextDay
                }
            }
            let hashKey = Results.HashKey(startDate: self.startDate,
                                          endDate: self.endDate,
                                          longitude: self.longitude,
                                          latitude: self.latitude)
            let results = Results(lockedInAspects: self.lockedInAspects, hashKey: hashKey)
            self.archive(results: results)
            self.exporter?.process(results: results)
            self.delegate?.scanComplete(aspectsFound: self.lockedInAspects)
        }
    }
    
    
    // MARK: Main Functions
    
    func scan()
    {
        print("scan")
        findAspectEvents()
    }
    
    func reset() {
        activelyScanningAspects = [:]
        lockedInAspects = [:]
        recentlyLockedInAspects = [:]
        state = .ready
    }
    
    func archive(results:AspectEventScanner.Results) {
        self.archive?.store(results: results)
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Float? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        guard let days = dateComponents.day else {return nil}
        return Float(days)
    }
}


extension AspectEventScanner {
    enum State {
        case ready
        case scanning
        case paused
        case done
        case fail
        
        var consoleText: String {
            switch self {
            case .ready: return "🟢 Ready"
            case .scanning: return "▶️ Scanning"
            case .paused: return "⏸️ Paused"
            case .done: return "✅ Done"
            case .fail: return "⚠️ Fail"
            }
        }
    }
}

extension AspectEventScanner {
    enum SampleMode {
        case simple
        case precise
        
        var consoleText: String {
            switch self {
            case .simple: return "Simple"
            case .precise: return "Precise"
            }
        }
    }
}

extension AspectEventScanner {
    enum ScanError: Error {
        case startAndEndDateAreSame
        case cannotGetTotalScanCountFromDates
    }
}
