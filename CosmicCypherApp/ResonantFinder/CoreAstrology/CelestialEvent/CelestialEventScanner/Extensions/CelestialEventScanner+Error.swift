//
//  CelestialEventScanner+Error.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

// MARK: Error
extension CelestialEventScanner {
    // Error Types of Scanner
    enum ScanError: Error {
        case startAndEndDateAreSame
        case cannotGetTotalScanCountFromDates
        case failureToGetRealDate
        case failureToGetRealAspect
        case recentlyLockedInAspectTypesMissing
        case skippingHashFailureToGetLongitudeDifferenceForPreviousAspectOnPreviousDate(_ hash:String)
        case failureToGetAspectTypeForDate(_ aspectType:String, _ date:Date)
        case failureToGetDaysForDateComponentsDay
        
        var text:String {
            switch self {
            case .startAndEndDateAreSame: 
                return "StartDate and EndDate are the same"
            case .cannotGetTotalScanCountFromDates:
                return "Cannot get Total Scan Count from Dates"
            case .failureToGetRealDate:
                return "FailureToGetRealDate from previousAspect via realDate"
            case .failureToGetRealAspect:
                return "FailureToGetRealAspect from previousAspect via realDate"
            case .recentlyLockedInAspectTypesMissing:
                return "Recently Locked In AspectTypes are Missing"
            case .skippingHashFailureToGetLongitudeDifferenceForPreviousAspectOnPreviousDate(let hash):
                return "Skipping Hash[\(hash)] - Failure to get longitudeDifference for previous aspect on previousDate"
            case .failureToGetAspectTypeForDate(let aspectType, let date):
                return "Failure to get AspectType[\(aspectType)] for Date\(date)"
            case .failureToGetDaysForDateComponentsDay:
                return "Failure to get days for dateComponents.day"
            }
        }
    }
}

// MARK: Handle Error
extension CelestialEventScanner {
    // Handle Error
    public func handleScanError(error: ScanError) {
        console?.error(.scanner, context: error.text)
        delegate?.scanError(error: error)
    }
}
