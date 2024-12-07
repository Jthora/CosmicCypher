//
//  CelestialEventScanner+Delegate.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation


protocol CelestialEventScannerDelegate {
    func scanUpdate(progress:Float)
    func scanComplete(results:CelestialEventScanner.Results)
    func subScanUpdate(progress:Float, type:CoreAstrology.CelestialEventType)
    func subScanComplete(results:CelestialEventScanner.SubScanResults, type:CoreAstrology.CelestialEventType)
    func deepScanUpdate(progress:Float, type:CoreAstrology.CelestialEventType)
    func deepScanComplete(event:CoreAstrology.CelestialEvent, type:CoreAstrology.CelestialEventType)
    func scanError(error:CelestialEventScanner.ScanError)
    func subScanError(error:CelestialEventScanner.ScanError)
    func deepScanError(error:CelestialEventScanner.ScanError)
}


extension CelestialEventScanner: CelestialEventScannerDelegate {
    
    
    
    // MARK: Delegate Functions
    // Update (Main)
    func scanUpdate(progress: Float) {
        handle(scanProgress: progress)
    }
    // Update (Sub Scan)
    func subScanUpdate(progress: Float, type: CoreAstrology.CelestialEventType) {
        handle(subScanProgress: progress, type: type)
    }
    // Update (Deep Scan)
    func deepScanUpdate(progress: Float, type: CoreAstrology.CelestialEventType) {
        handle(deepScanProgress: progress, type: type)
    }
    
    // Complete (Main)
    func scanComplete(results: Results) {
        handle(scanComplete: results)
    }
    // Complete (Sub Scan)
    func subScanComplete(results: SubScanResults, type: CoreAstrology.CelestialEventType) {
        handle(subScanComplete: results, type: type)
    }
    // Complete (Deep Scan)
    func deepScanComplete(event: CoreAstrology.CelestialEvent, type: CoreAstrology.CelestialEventType) {
        handle(deepScanComplete: event, type: type)
    }
    
    // Error (Main Scanner)
    func scanError(error: ScanError) {
        handle(scanError: error)
    }
    // Error (Sub Scanner)
    func subScanError(error: ScanError) {
        handle(scanError: error)
    }
    // Error (Deep Scanner)
    func deepScanError(error: ScanError) {
        handle(scanError: error)
    }
    
    // MARK: Handler Functions
    // Main Scan Update
    func handle(scanProgress: Float?) {
        guard let progress = scanProgress else {return}
        delegate?.scanUpdate(progress: progress)
    }
    // Sub Scan Update
    func handle(subScanProgress: Float?, type: CoreAstrology.CelestialEventType) {
        guard let progress = subScanProgress else {return}
        delegate?.subScanUpdate(progress: progress, type: type)
    }
    // Deep Scan Update
    func handle(deepScanProgress: Float?, type: CoreAstrology.CelestialEventType) {
        guard let progress = deepScanProgress else {return}
        self.delegate?.deepScanUpdate(progress: progress, type: type)
    }
    // Scan Complete
    func handle(scanComplete results: Results) {
        self.delegate?.scanComplete(results: results)
        // Archive Results
        //self.archive(results: results)
    }
    // Sub Scan Complete
    func handle(subScanComplete results: SubScanResults, type: CoreAstrology.CelestialEventType) {
        self.delegate?.subScanComplete(results: results, type: type)
        // Archive Results
        //self.archive(results: results)
    }
    // Deep Scan Complete
    func handle(deepScanComplete event: CoreAstrology.CelestialEvent, type: CoreAstrology.CelestialEventType) {
        self.delegate?.deepScanComplete(event: event, type: type)
        // Archive Results
        //self.archive(results: results)
    }
    
    
    // Scan Error
    func handle(scanError:ScanError) {
        self.delegate?.scanError(error: scanError)
        // Report Error on Console
        self.console?.error(.scanner, context: scanError.text)
    }
    
}
