//
//  AspectEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import Foundation
import SwiftAA

class AspectEventScanner {
    
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
    public lazy var scanner:Scanner = {
        var scanner = Scanner()
        scanner.delegate = self
        return Scanner()
    }()
    
    var state: AspectEventScanner.State {
        get {
            return scanner.state
        }
        set {
            scanner.state = newValue
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
    
    // MARK: External Main Functions

    // External Call to perform a Scan
    public func scan()
    {
        print("scan")
        scanner.startScanner(startDate: startDate,
                             endDate: endDate)
    }
    
    // External Call to Reset the Scanner
    public func reset() {
        scanner.resetScanner()
    }
    
    // Archive Results
    func archive(results:AspectEventScanner.Results) {
        self.archive?.store(results: results)
    }
}


