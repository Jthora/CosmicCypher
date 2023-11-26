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
    
    // MARK: Properties
    var useRetrogradeScanner:Bool = true
    var useAspectScanner:Bool = true
    var useTransitScanner:Bool = true
    var useFormationScanner:Bool = true
    var useOctiveScanner:Bool = true
    var useResonanceScanner:Bool = true
    
    var useDeepScan:Bool = true
    
    // MARK: Scanners
    // Aspect Event Scanner
    public lazy var aspectEventScanner:AspectEventScanner = {
        var scanner = AspectEventScanner()
        scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return AspectEventScanner()
    }()
    // Formation Event Scanner
    public lazy var formationEventScanner:AspectEventScanner = {
        var scanner = AspectEventScanner()
        scanner.delegate = self
        scanner.useDeepScan = useDeepScan
        return AspectEventScanner()
    }()
    // Sample Mode
    public var sampleMode:SampleMode {
        get {
            return aspectEventScanner.sampleMode
        }
        set {
            aspectEventScanner.sampleMode = newValue
            DispatchQueue.main.async {
                self.console?.updated(sampleMode: newValue)
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
    var state: CelestialEventScanner.State {
        get {
            return aspectEventScanner.state
        }
        set {
            aspectEventScanner.state = newValue
        }
    }
    
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
    
    // MARK: Public Main Functions

    // External Call to perform a Scan
    public func scan()
    {
        print("scan")
        aspectEventScanner.delegate = self
        aspectEventScanner.startScanner(startDate: startDate,
                             endDate: endDate)
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


