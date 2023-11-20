//
//  AspectEventScanner+Error.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

// MARK: Error
extension AspectEventScanner {
    // Error Types of Scanner
    enum ScanError: Error {
        case startAndEndDateAreSame
        case cannotGetTotalScanCountFromDates
        case failureToGetRealDate
        
        var text:String {
            switch self {
            case .startAndEndDateAreSame: return "Start Date == End Date"
            case .cannotGetTotalScanCountFromDates: return "Cannot get Total Scan Count from Dates"
            case .failureToGetRealDate: return "FailureToGetRealDate from previousAspect via realDate"
            }
        }
    }
}

extension AspectEventScanner {
    // Handle Error
    public func handleScanError(error: ScanError) {
        console?.error(.scanner, context: error.text)
        delegate?.scanError(error: error)
    }
}

extension AspectEventScanner.Scanner {
}
