//
//  AspectEventScanner+Delegate.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

protocol AspectEventScannerDelegate {
    func scanUpdate(scanProgress:Float?)
    func scanUpdate(subScanProgress:Float?)
    func scanUpdate(calculateProgress:Float?)
    func scanUpdate(deepScanProgress:Float?)
    func scanComplete(aspectsFound:[Date: [CoreAstrology.Aspect]])
    func deepScanComplete(date:Date)
    func scanError(error:AspectEventScanner.ScanError)
}


extension AspectEventScanner: AspectEventScannerDelegate {
    
    // MARK: Delegate Functions
    // Scan
    func scanUpdate(scanProgress: Float?) {
        handle(scanProgress: scanProgress)
    }
    
    // Sub Scan
    func scanUpdate(subScanProgress: Float?) {
        handle(subScanProgress: subScanProgress)
    }
    
    // Calculate
    func scanUpdate(calculateProgress: Float?) {
        handle(calculateProgress: calculateProgress)
    }
    
    // Deep Scan
    func scanUpdate(deepScanProgress: Float?) {
        handle(deepScanProgress: deepScanProgress)
    }
    
    // Complete
    func scanComplete(aspectsFound: [Date : [CoreAstrology.Aspect]]) {
        handle(scanComplete: aspectsFound)
    }
    
    // Deep Scan Complete
    func deepScanComplete(date: Date) {
        handle(deepScanComplete: date)
    }
    
    // Error
    func scanError(error: ScanError) {
        handle(scanError: error)
    }
    
    
    // MARK: Handler Functions
    // Scan Update
    func handle(scanProgress: Float?) {
        delegate?.scanUpdate(scanProgress: scanProgress)
    }
    
    // Sub Scan Update
    func handle(subScanProgress: Float?) {
        delegate?.scanUpdate(subScanProgress: subScanProgress)
    }
    
    // Calculate Update
    func handle(calculateProgress: Float?) {
        delegate?.scanUpdate(calculateProgress: calculateProgress)
    }
    
    // Deep Scan Update
    func handle(deepScanProgress: Float?) {
        self.delegate?.scanUpdate(deepScanProgress: deepScanProgress)
    }
    
    // Scan Complete
    func handle(scanComplete aspectsFound: [Date: [CoreAstrology.Aspect]]) {
        self.delegate?.scanComplete(aspectsFound: aspectsFound)
        // Archive Results
        self.archiveResults(aspectsFound: aspectsFound)
    }
    
    func handle(deepScanComplete date: Date) {
        self.delegate?.deepScanComplete(date: date)
    }
    
    // Scan Error
    func handle(scanError:ScanError) {
        self.delegate?.scanError(error: scanError)
        // Report Error on Console
        self.console?.error(.scanner, context: scanError.text)
    }
    
}
