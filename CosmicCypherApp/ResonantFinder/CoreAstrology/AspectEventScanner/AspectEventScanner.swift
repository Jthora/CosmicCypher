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
    public var state:State {
        get {
            return _state
        }
        set {
            _state = newValue
        }
    }
    
    // Mode
    public var mode:SampleMode = .simple {
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(sampleMode: self.mode)
            }
        }
    }
    
    // Delegate
    public var delegate:AspectEventScannerDelegate? = nil
    public weak var console:AspectEventConsole? = nil
    public weak var exporter:AspectEventExporter? = nil
    public weak var archive:AspectEventDataArchive? = nil
    
    // DateTime
    public lazy var startDate: Date = StarChart.Core.current.date {
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(startDate: self.startDate)
            }
        }
    }
    public lazy var currentDate: Date = StarChart.Core.current.date{
        didSet {
            //console?.updatedDates()
        }
    }
    public lazy var endDate: Date = StarChart.Core.current.date{
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(endDate: self.endDate)
            }
        }
    }
    
    // GeoLocation
    private lazy var _coordinates: GeographicCoordinates = StarChart.Core.current.coordinates
    public var coordinates: GeographicCoordinates {
        get {
            return _coordinates
        }
        set {
            _coordinates = newValue
            console?.updated(coordinates: _coordinates)
        }
    }
    
    public var longitude: Double {
        get {
            _coordinates.longitude.value
        }
        set {
            let newCoordinates = GeographicCoordinates(positivelyWestwardLongitude: Degree(newValue), latitude: _coordinates.latitude)
            _coordinates = newCoordinates
            console?.updated(longitude: newValue)
        }
    }
    
    public var latitude: Double {
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
    public var selectedNodeTypes:[CoreAstrology.AspectBody.NodeType] {
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
    public var selectedAspects:[CoreAstrology.AspectRelationType] {
        get {
            return _selectedAspects
        }
        set {
            _selectedAspects = newValue
            //console?.updatedAspectAngles()
        }
    }
    
    
    // MARK: Scan
    // Parsing Buffers
    private var activelyScanningAspectEvents:[CoreAstrology.AspectType.SymbolHash: CoreAstrology.AspectEvent] = [:]
    private var recentlyLockedInAspectTypes:[CoreAstrology.AspectType.SymbolHash: Bool] = [:]
    
    // Locked In Aspects
    private var lockedInAspects: [Date: [CoreAstrology.Aspect]] = [:]
    private func lockIn(aspect: CoreAstrology.Aspect, for date:Date) {
        var aspectArray:[CoreAstrology.Aspect] = lockedInAspects[date] ?? []
        aspectArray.append(aspect)
        lockedInAspects[date] = aspectArray
    }
    
    // Reset Scanner
    private func resetScanner() {
        activelyScanningAspectEvents = [:]
        recentlyLockedInAspectTypes = [:]
        lockedInAspects = [:]
        state = .ready
    }
    
    // Start Scanner
    private func startScanner() {
        resetScanner()
        state = .scanning
        
        // Make Sure that Start Date isn't the same as End Date
        guard startDate != endDate else {
            handleScanError(error: .startAndEndDateAreSame, context: "Start Date == End Date")
            return
        }

        // Get Total Scans based on the number of Days between Start Date and End Date
        guard let totalScanCount = daysBetweenDates(startDate: startDate, endDate: endDate) else {
            handleScanError(error: .cannotGetTotalScanCountFromDates, context: "Cannot get Total Scan Count from Dates")
            return
        }
        
        // Find Aspects
        // Establish a list of Types for Bodies and Relations (Planets and Angles)
        let relationTypes: Set<CoreAstrology.AspectRelationType> = Set(AspectEventScanner.Core.aspectAngles)
        let nodeTypes: Set<CoreAstrology.AspectBody.NodeType> = Set(AspectEventScanner.Core.planetsAndNodes)
        
        // List AspectTypes
        let aspectTypes = createListOfAspectTypes(relationTypes: relationTypes, nodeTypes: nodeTypes)
        print("Aspects To Scan: \(aspectTypes.map({$0.hash}))")
        
        // Scan for Aspects
        scan(aspectTypes: aspectTypes, totalScanCount: totalScanCount)
    }
    
    // Create a list of all the aspect types we are scanning
    func createListOfAspectTypes(relationTypes:Set<CoreAstrology.AspectRelationType>, nodeTypes:Set<CoreAstrology.AspectBody.NodeType>) -> [CoreAstrology.AspectType] {
        
        // Setup for creating List
        let nodeTypes = nodeTypes.enumerated()
        var aspectTypes:[CoreAstrology.AspectType] = []
        
        // Iterate through each Body Type (for first body)
        for (index1, nodeType1) in nodeTypes {
            
            // Iterate through each Body Type (for second body)
            for (_, nodeType2) in nodeTypes.dropFirst(index1 + 1) { // Avoid duplicate and reverse combinations
                
                // Iterate through each Aspect Type
                for relationType in relationTypes {
                    let aspectType = CoreAstrology.AspectType(primaryBodyType: nodeType1, relationType: relationType, secondaryBodyType: nodeType2)
                    aspectTypes.append(aspectType)
                }
            }
        }
        return aspectTypes
    }
    
    // Go through every day and scan for Aspects that are within orb
    private func scan(aspectTypes: [CoreAstrology.AspectType], totalScanCount:Float) {
        print("scanning aspects")
        
        // Perform on Background Thread
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Scanning Properties
            var currentDate = self.startDate
            var scanCount: Float = 0
            
            // Scanning Loop
            while currentDate <= self.endDate {
                // Number of Iterations
                scanCount += 1
                let progress = scanCount / totalScanCount
                
                // Report progress to Console UI
                DispatchQueue.main.async {
                    AspectEventScanner.Core.console.scanning(scans: Int(scanCount),
                                           scrying: self.activelyScanningAspectEvents.count,
                                           discovered: self.lockedInAspects.count)
                    self.delegate?.scanUpdate(progress: progress, subProgress: 0)
                }
                
                // Find Aspects within Orb
                print("finding aspects for types: \(aspectTypes.map({$0.hash}))")
                let aspects = self.findAspectsWithinOrb(aspectTypes: aspectTypes, on: currentDate)
                print("found aspects: \(aspects.map({$0.hash}))")
                
                // Calculate Aspects
                self.calculate(aspects: aspects, on: currentDate)

                // determine the next scan date
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }

            // Archive Results
            self.archiveResults()
            
            // Report Complete to Delegate
            self.delegate?.scanComplete(aspectsFound: self.lockedInAspects)
        }
    }
    
    // Find Aspects for Date based on Types
    private func findAspectsWithinOrb(aspectTypes:[CoreAstrology.AspectType], on date:Date) -> [CoreAstrology.Aspect] {
        var aspects: [CoreAstrology.Aspect] = []
        for aspectType in aspectTypes {
            print("checking orb for: \(aspectType.hash)")
            guard let aspect = aspectType.aspect(for: date) else {continue}
            print("found aspect within orb: \(aspect.hash)")
            aspects.append(aspect)
        }
        return aspects
    }
    
    // Cycle through Aspects and Planets looking for Orbs at 0º
    private func calculate(aspects:[CoreAstrology.Aspect], on currentDate:Date) {
        print("Calculating: \(currentDate)")
        
        // Iterate through Aspects
        for currentAspect in aspects {
            print("Iterating: \(currentAspect.hash)")
            
            // Symbol Hash
            let hash = currentAspect.hash
            
            // Current Aspect Distance
            guard let currentDistance = currentAspect.longitudeDifference(for: currentDate) else {
                print("Skipping \(hash) (FAILURE to get longitudeDifference for \(currentAspect) on \(currentDate)")
                continue
            }
            
            // Ensure that aspect isn't Recently Locked In
            guard recentlyLockedInAspectTypes[hash] == nil else {
                print("Skipping \(hash) (recently Locked In)")
                continue // Skip to next aspect
            }
            
            // If Previous Aspect exists, compare with Current Aspect
            if let previousAspectEvent = activelyScanningAspectEvents[hash] {
                print("Comparing \(previousAspectEvent.aspect.type.hash) with \(currentAspect.type.hash)")
                
                // Previous Date, Aspect and Distance
                let previousDate = previousAspectEvent.date
                let previousAspect = previousAspectEvent.aspect
                guard let previousDistance = previousAspect.longitudeDifference(for: previousDate) else {
                    print("Skipping \(hash) (FAILURE to get longitudeDifference for \(previousAspect) on \(previousDate))")
                    continue
                }
                
                // Is current aspect closer to 0º than previous?
                let isCloser = abs(currentDistance) <= abs(previousDistance)
                
                // If closer, update aspect
                if isCloser {
                    print("Closing In on (\(hash)) for [\(currentDate)] at [\(currentDistance)]")
                    
                    // Update Aspect because it's closer to 0º orb
                    activelyScanningAspectEvents[hash] = CoreAstrology.AspectEvent(aspect: currentAspect, date: currentDate)
                } else {
                    // else
                    print("Locking In (\(hash)) for [\(previousDate)] at [\(previousDistance)]")
                    
                    // No longer Actively Scanning Aspect
                    self.activelyScanningAspectEvents.removeValue(forKey: hash)
                    
                    // Deep Scan to aquire the Exact Time of Date for the Aspect Event
                    let realDate = deepScan(aspect: previousAspect, for: previousDate)
                    guard let realAspect = CoreAstrology.Aspect(type: previousAspect.type, date: realDate) else {
                        print("FailureToGetRealDate \(previousAspect): \(realDate)")
                        self.handleScanError(error: .failureToGetRealDate, context: "\(previousAspect): \(realDate)")
                        continue
                    }
                    
                    // Lock In the Aspect
                    lockIn(aspect: realAspect, for: realDate)
                    
                    // Set that the Aspect was recently Locked in
                    recentlyLockedInAspectTypes[hash] = true
                }
                
            } else {
                // No Previous Aspect Date (initial state) add
                print("Newly detected Aspect \(hash)")
                activelyScanningAspectEvents[hash] = CoreAstrology.AspectEvent(aspect: currentAspect, date: currentDate)
            }
        }

        print("Considering removal of locked in aspects...")
        // remove recentlyLockedInAspects that are no longer being detected
        let symbolHashes = aspects.map { $0.hash }
        
        // Check all Recently Locked In Aspects to see if they are no longer being considered for active scan
        for (key, _) in recentlyLockedInAspectTypes {
            // Remove Recently Locked In Flag, as it's not being scanned anymore and may appear again in the future
            if !symbolHashes.contains(key) {
                print("Clearing recently locked in aspect: \(key)")
                recentlyLockedInAspectTypes.removeValue(forKey: key)
            }
        }
    }

    // Archive the currently Locked In Aspects
    private func archiveResults() {
        // Archiving Results
        print("Archiving Results")
        let hashKey = Results.HashKey(startDate: self.startDate,
                                      endDate: self.endDate,
                                      longitude: self.longitude,
                                      latitude: self.latitude)
        let results = Results(lockedInAspects: self.lockedInAspects, hashKey: hashKey)
        self.archive(results: results)
    }
    
    // Handle Error
    private func handleScanError(error: AspectScanError, context: String) {
        state = .fail
        console?.error(.scanner, context: context)
        delegate?.scanError(error: error)
        state = .ready
    }
    
    
    // MARK: External Main Functions

    // External Call to perform a Scan
    public func scan()
    {
        print("scan")
        startScanner()
    }
    
    // External Call to Reset the Scanner
    public func reset() {
        resetScanner()
    }
    
    // Archive Results
    func archive(results:AspectEventScanner.Results) {
        self.archive?.store(results: results)
    }
    
    // Get the number of days between two dates
    func daysBetweenDates(startDate: Date, endDate: Date) -> Float? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        guard let days = dateComponents.day else {return nil}
        return Float(days)
    }
}

// MARK: Extensions

extension AspectEventScanner {
    // State of Scanner
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
    // Sample Mode of Scanner
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
    // Error Types of Scanner
    enum AspectScanError: Error {
        case startAndEndDateAreSame
        case cannotGetTotalScanCountFromDates
        case failureToGetRealDate
    }
}

// MARK: Deep Scanner
extension AspectEventScanner {
    // Deep Scanner
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
                  let b2 = CoreAstrology.AspectBody(type: secondaryObject.type, date: midDate),
                  let longitudeDifference: Degree = b1.longitudeDifference(from: b2, on: midDate) else {
                break
            }
            // Calculate the aspect angle between the two planetary bodies
            //.longitudeAngle(relativeTo: b2)
            
            // Calculate the difference between the aspect angle and the orb distance
            let distance = abs(longitudeDifference.value - targetAspectAngle)
            
            if distance < minDistance {
                minDistance = distance
                closestDate = midDate
            }
            
            // Check if the aspect angle is within the target orb threshold
            if distance < targetOrbThreshold {
                // If it is, we found an aspect within the desired orb, so we can exit the loop early
                break
            }
            
            if longitudeDifference.value > targetAspectAngle {
                lowerBoundTimeInterval = midTimeInterval
            } else {
                upperBoundTimeInterval = midTimeInterval
            }
        }
        
        return closestDate
    }
}
