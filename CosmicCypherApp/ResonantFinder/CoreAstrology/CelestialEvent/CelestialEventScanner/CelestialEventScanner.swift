//
//  CelestialEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import Foundation
import SwiftAA

// MARK: Aspect Event Scanner
class CelestialEventScanner {
    
    // MARK: Results
    // Scan Results
    var scanResults:ScanResults = ScanResults()
    
    // MARK: Settings
    // Options
    var useRetrogradeScanner:Bool = true
    var useAspectScanner:Bool = true
    var useTransitScanner:Bool = true
    var useFormationScanner:Bool = true
    var useOctiveScanner:Bool = true
    var useResonanceScanner:Bool = true
    
    // Deep Scan Setting
    var useDeepScan:Bool = true {
        didSet {
            retrogradeEventScanner.useDeepScan = self.useDeepScan
            transitEventScanner.useDeepScan = self.useDeepScan
            aspectEventScanner.useDeepScan = self.useDeepScan
            formationEventScanner.useDeepScan = self.useDeepScan
            octiveEventScanner.useDeepScan = self.useDeepScan
            resonanceEventScanner.useDeepScan = self.useDeepScan
        }
    }
    
    // MARK: Scanners
    // Retrograde Event Scanner
    public lazy var retrogradeEventScanner:RetrogradeEventScanner = {
        var scanner = RetrogradeEventScanner()
        //scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return RetrogradeEventScanner()
    }()
    // Aspect Event Scanner
    public lazy var transitEventScanner:TransitEventScanner = {
        var scanner = TransitEventScanner()
        //scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return TransitEventScanner()
    }()
    // Aspect Event Scanner
    public lazy var aspectEventScanner:AspectEventScanner = {
        var scanner = AspectEventScanner()
        scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return AspectEventScanner()
    }()
    // Formation Event Scanner
    public lazy var formationEventScanner:FormationEventScanner = {
        var scanner = FormationEventScanner()
        //scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return FormationEventScanner()
    }()
    // Formation Event Scanner
    public lazy var octiveEventScanner:OctiveEventScanner = {
        var scanner = OctiveEventScanner()
        //scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return OctiveEventScanner()
    }()
    // Formation Event Scanner
    public lazy var resonanceEventScanner:ResonanceEventScanner = {
        var scanner = ResonanceEventScanner()
        //scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return ResonanceEventScanner()
    }()
    
    // MARK: Operation Queue
    // Operation Queue
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // Ensure one operation runs at a time
        return queue
    }()
    
    
    // MARK: Properties
    // Sample Mode
    public var sampleMode:SampleMode = .hour {
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(sampleMode: self.sampleMode)
            }
        }
    }
    // Delegate
    public var delegate:CelestialEventScannerDelegate? = nil
    // References
    public weak var console:CelestialEventConsole? = nil
    public weak var exporter:CelestialEventExporter? = nil
    public weak var archive:CelestialEventDataArchive? = nil
    // State
    var state: CelestialEventScanner.State = .ready
    
    // Start Date
    public lazy var startDate: Date = Date.beginningOf(.thisYear)! { // StarChart.Core.current.date
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(startDate: self.startDate)
            }
        }
    }
    // Current Date
    public lazy var currentDate: Date = StarChart.Core.current.date {
        didSet {
            //console?.updatedDates()
        }
    }
    // End Date
    public lazy var endDate: Date = Date.endOf(.thisYear)! { // StarChart.Core.current.date
        didSet {
            DispatchQueue.main.async {
                self.console?.updated(endDate: self.endDate)
            }
        }
    }
    
    // GeoLocation
    lazy var _coordinates: GeographicCoordinates = StarChart.Core.current.coordinates
    public var coordinates: GeographicCoordinates {
        get {
            return _coordinates
        }
        set {
            _coordinates = newValue
            console?.updated(coordinates: _coordinates)
        }
    }
    // Longitude
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
    // Latitude
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
    
    // Planet Nodes
    lazy var _selectedNodeTypes:[CoreAstrology.AspectBody.NodeType] = StarChart.Core.selectedNodeTypes
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
    lazy var _selectedAspects: [CoreAstrology.AspectRelationType]  = StarChart.Core.selectedAspects
    public var selectedAspects:[CoreAstrology.AspectRelationType] {
        get {
            return _selectedAspects
        }
        set {
            _selectedAspects = newValue
            //console?.updatedAspectAngles()
        }
    }
    
    // MARK: Main Scan
    // Scan
    public func scan()
    {
        /// Startup
        let startupOperation = StartupOperation()
        operationQueue.addOperation(startupOperation)
        /// Retrograde Scan
        if useRetrogradeScanner {
            let retrogradeOperation = RetrogradeScanOperation()
            retrogradeOperation.scanner = retrogradeEventScanner
            operationQueue.addOperation(retrogradeOperation)
        }
        /// Transit Scan
        if useTransitScanner {
            let transitOperation = TransitScanOperation()
            transitOperation.scanner = transitEventScanner
            operationQueue.addOperation(transitOperation)
        }
        /// Aspect Scan
        if useAspectScanner {
            let aspectOperation = AspectScanOperation()
            aspectOperation.scanner = aspectEventScanner
            operationQueue.addOperation(aspectOperation)
        }
        /// Formation Scan
        if useFormationScanner {
            let formationOperation = FormationScanOperation()
            formationOperation.scanner = formationEventScanner
            operationQueue.addOperation(formationOperation)
        }
        /// Octive Scan
        if useOctiveScanner {
            let octiveOperation = OctiveScanOperation()
            octiveOperation.scanner = octiveEventScanner
            operationQueue.addOperation(octiveOperation)
        }
        /// Resonance Scan
        if useResonanceScanner {
            let resonanceOperation = ResonanceScanOperation()
            resonanceOperation.scanner = resonanceEventScanner
            operationQueue.addOperation(resonanceOperation)
        }
        /// Complete
        let completeOperation = CompletionOperation()
        operationQueue.addOperation(completeOperation)
        
    }
    
    // External Call to Reset the Scanner
    public func reset() {
        aspectEventScanner.resetScanner()
    }
    
    // Archive Results
    func archive(results:CelestialEventScanner.Results) {
        self.archive?.store(results: results)
    }
}

// MARK: Sub Scanner
extension CelestialEventScanner {
    // Sub Scanner
    class SubScanner {}
}

// MARK: Startup and Complete Operations
extension CelestialEventScanner {
    class StartupOperation: Operation {
        override func main() {
            // Perform startup tasks here before other operations start
            print("Startup tasks completed")
        }
    }

    class CompletionOperation: Operation {
        override func main() {
            // Perform completion tasks here after all other operations finish
            print("All operations completed")
        }
    }

}
