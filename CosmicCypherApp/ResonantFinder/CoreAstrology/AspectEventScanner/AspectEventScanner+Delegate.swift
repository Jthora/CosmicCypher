//
//  AspectEventScanner+Delegate.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

protocol AspectEventScannerDelegate {
    func scanUpdate(scanProgress:Float?)
    func scanUpdate(deepScanProgress:Float?)
    func scanError(error:AspectEventScanner.ScanError)
    func scanComplete(aspectsFound:[Date: [CoreAstrology.Aspect]])
}


extension AspectEventScanner: AspectEventScannerDelegate {
    
    // MARK: Delegate Functions
    func scanUpdate(scanProgress: Float?) {
        handle(scanProgress: scanProgress)
    }
    
    func scanUpdate(deepScanProgress: Float?) {
        handle(deepScanProgress: deepScanProgress)
    }
    
    func scanError(error: ScanError) {
        handle(scanError: error)
    }
    
    func scanComplete(aspectsFound: [Date : [CoreAstrology.Aspect]]) {
        handle(scanComplete: aspectsFound)
    }
    
    
    // MARK: Handler Functions
    // Scan Update
    func handle(scanProgress: Float?) {
        delegate?.scanUpdate(scanProgress: scanProgress)
    }
    
    // Deep Scan Update
    func handle(deepScanProgress: Float?) {
        self.delegate?.scanUpdate(deepScanProgress: deepScanProgress)
    }
    
    //
    func handle(scanComplete aspectsFound: [Date: [CoreAstrology.Aspect]]) {
        self.delegate?.scanComplete(aspectsFound: aspectsFound)
        // Archive Results
        self.archiveResults(aspectsFound: aspectsFound)
    }
    
    func handle(scanError:ScanError) {
        self.delegate?.scanError(error: scanError)
    }
    
}
