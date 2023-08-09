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
    func scanError(error:AspectEventScanner.AspectScanError)
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
    
    var activelyScanningAspects:[CoreAstrology.Aspect.SymbolHash: (aspect: CoreAstrology.Aspect, date: Date)] = [:]
    var recentlyLockedInAspects:[CoreAstrology.Aspect.SymbolHash:Bool] = [:]
    
    var lockedInAspects: [Date: [CoreAstrology.Aspect]] = [:]
    func lockIn(aspect: CoreAstrology.Aspect, for date:Date) {
        var aspectArray:[CoreAstrology.Aspect] = lockedInAspects[date] ?? []
        aspectArray.append(aspect)
        lockedInAspects[date] = aspectArray
    }
    
    func resetScanner() {
        activelyScanningAspects = [:]
        recentlyLockedInAspects = [:]
        lockedInAspects = [:]
    }
    
    func startScanner() {
        resetScanner()
        state = .scanning
        
        guard startDate != endDate else {
            handleScanError(error: .startAndEndDateAreSame, context: "Start Date == End Date")
            return
        }

        guard let totalScanCount = daysBetweenDates(startDate: startDate, endDate: endDate) else {
            handleScanError(error: .cannotGetTotalScanCountFromDates, context: "Cannot get Total Scan Count from Dates")
            return
        }
        
        // Find Aspects
        let aspects = findAspectEvents()
        
        // Scanning Properties
        var currentDate = startDate
        let nodeTypes: [CoreAstrology.AspectBody.NodeType] = AspectEventScanner.Core.planetsAndNodes
        var scanCount: Float = 0
        
        // Background Thread
        DispatchQueue.global(qos: .userInitiated).async {
            // Scanning Loop
            while currentDate <= self.endDate {
                // Number of Iterations
                scanCount += 1
                let progress = scanCount / totalScanCount
                
                // Report progress to Console UI
                DispatchQueue.main.async {
                    self.console?.scanning(scans: Int(scanCount),
                                           scrying: self.activelyScanningAspects.count,
                                           discovered: self.lockedInAspects.count)
                    self.delegate?.scanUpdate(progress: progress, subProgress: 0)
                }
                self.calculate(aspects: aspects, for: nodeTypes, on: currentDate)

                // determine the next scan date
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }

            self.archiveResults()
            self.delegate?.scanComplete(aspectsFound: self.lockedInAspects)
        }
    }
    
    
    func findAspectEvents() -> [CoreAstrology.Aspect] {

        var currentDate = startDate
        let aspectTypes: Set<CoreAstrology.AspectRelationType> = Set(AspectEventScanner.Core.aspectAngles)
        let nodeTypes: [CoreAstrology.AspectBody.NodeType] = AspectEventScanner.Core.planetsAndNodes

        // Aspects
        var aspects: [CoreAstrology.Aspect] = []
        for (index1, nodeType1) in nodeTypes.enumerated() {
            guard let longitude1 = nodeType1.geocentricLongitude(date: currentDate),
                  let body1 = CoreAstrology.AspectBody(type: nodeType1, date: currentDate) else { continue }
            
            for nodeType2 in nodeTypes.dropFirst(index1 + 1) { // Avoid duplicate and reverse combinations
                guard let longitude2 = nodeType2.geocentricLongitude(date: currentDate),
                      let body2 = CoreAstrology.AspectBody(type: nodeType2, date: currentDate),
                      let relation = CoreAstrology.AspectRelation(degrees: longitude1 - longitude2) else { continue }
                
                if aspectTypes.contains(relation.type) {
                    // Create Aspect
                    let aspect = CoreAstrology.Aspect(primaryBody: body1,
                                                      relation: relation,
                                                      secondaryBody: body2)
                    aspects.append(aspect)
                }
            }
        }
        
        return aspects
    }

    private func handleScanError(error: AspectScanError, context: String) {
        state = .fail
        console?.error(.scanner, context: context)
        delegate?.scanError(error: error)
        state = .ready
    }
    
    private func calculate(aspects:[CoreAstrology.Aspect], for planets:[CoreAstrology.AspectBody.NodeType], on date:Date) {
        for thisAspect in aspects {
            let hash = thisAspect.symbolHash
            let recentlyLocked = recentlyLockedInAspects[hash]
            var previousAspectDate = activelyScanningAspects[hash]?.1
            var previousOrbDistance = activelyScanningAspects[hash]?.0.longitudeAngle ?? Double.greatestFiniteMagnitude
            //let thisOrb = thisAspect.relation.type.rawValue
            let thisOrbDistance = thisAspect.longitudeAngle

            guard recentlyLocked == nil else {
                continue
            }

            if let prevDate = previousAspectDate, abs(thisOrbDistance) >= abs(previousOrbDistance) {
                self.activelyScanningAspects[hash] = nil
                let realDate = deepScan(aspect: thisAspect, for: prevDate)
                lockIn(aspect: thisAspect, for: realDate)
                recentlyLockedInAspects[hash] = true
            } else {
                activelyScanningAspects[hash] = (aspect: thisAspect, date: date)
            }
        }

        // remove recentlyLockedInAspects that are no longer being detected
        let symbolHashes = aspects.map { $0.symbolHash }
        for (key, _) in recentlyLockedInAspects where !symbolHashes.contains(key) {
            recentlyLockedInAspects.removeValue(forKey: key)
        }
    }

    private func calculateAspects(for starChart: StarChart, on date: Date) {
        let aspects = starChart.aspects.filter { aspect in
            return selectedAspects.contains(aspect.relation.type)
                && selectedNodeTypes.contains(aspect.primaryBody.type)
                && selectedNodeTypes.contains(aspect.secondaryBody.type)
        }

        
    }

    private func archiveResults() {
        let hashKey = Results.HashKey(startDate: self.startDate,
                                      endDate: self.endDate,
                                      longitude: self.longitude,
                                      latitude: self.latitude)
        let results = Results(lockedInAspects: self.lockedInAspects, hashKey: hashKey)
        self.archive(results: results)
    }
    
    
    // MARK: Main Functions
    
    func scan()
    {
        print("scan")
        startScanner()
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
    enum AspectScanError: Error {
        case startAndEndDateAreSame
        case cannotGetTotalScanCountFromDates
    }
}

    
extension AspectEventScanner {
    
    func deepScan(aspect: CoreAstrology.Aspect, for estimatedDate: Date) -> Date {
        // Calculate the exact date and time of the aspect
        let aspectDate = calculateAspectDate(estimatedDate: estimatedDate,
                                             primaryObject: aspect.primaryBody,
                                             secondaryObject: aspect.secondaryBody,
                                             aspectRelation: aspect.relation)
        return aspectDate
    }
    
    private func calculateAspectDate(estimatedDate: Date,
                                      primaryObject: CoreAstrology.AspectBody,
                                      secondaryObject: CoreAstrology.AspectBody,
                                      aspectRelation: CoreAstrology.AspectRelation) -> Date {
        let p1Type = primaryObject.type
        let p2Type = secondaryObject.type
        let targetAspectType = aspectRelation.type
        let targetAspectAngle = targetAspectType.rawValue
        let targetOrbThreshold = 0.01 // Set the target orb threshold to 0.01 degrees
        
        // Calculate the TimeInterval for 24 hours
        let oneDay: TimeInterval = 24 * 60 * 60
        
        // Calculate the TimeInterval range for 24 hours before and after the estimatedDate
        let startTimeInterval = estimatedDate.timeIntervalSinceReferenceDate - oneDay
        let endTimeInterval = estimatedDate.timeIntervalSinceReferenceDate + oneDay
        
        var closestDate = estimatedDate
        var minDistance = Double.greatestFiniteMagnitude
        
        var lowerBoundTimeInterval = startTimeInterval
        var upperBoundTimeInterval = endTimeInterval
        
        while upperBoundTimeInterval - lowerBoundTimeInterval >= 1.0 {
            // Perform a binary search to find the closest aspect date
            
            let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
            let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
            
            guard let b1 = CoreAstrology.AspectBody(type: primaryObject.type, date: midDate),
                  let b2 = CoreAstrology.AspectBody(type: secondaryObject.type, date: midDate) else {
                break
            }
            // Calculate the aspect angle between the two planetary bodies
            let positionAngle: Double = b1.longitudeAngle(relativeTo: b2)
            
            // Calculate the difference between the aspect angle and the orb distance
            let distance = abs(positionAngle - targetAspectAngle)
            
            if distance < minDistance {
                minDistance = distance
                closestDate = midDate
            }
            
            // Check if the aspect angle is within the target orb threshold
            if distance < targetOrbThreshold {
                // If it is, we found an aspect within the desired orb, so we can exit the loop early
                break
            }
            
            if positionAngle > targetAspectAngle {
                lowerBoundTimeInterval = midTimeInterval
            } else {
                upperBoundTimeInterval = midTimeInterval
            }
        }
        
        return closestDate
    }
}
