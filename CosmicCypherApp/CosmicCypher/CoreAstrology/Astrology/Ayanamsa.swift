//
//  Ayanamsa.swift
//  Project2501
//
//  Created by Jordan Trana on 4/27/22.
//

import Foundation
import SwiftAA

extension CoreAstrology {
    
    public enum Ayanamsa: Double {
        case galacticCenter
        case tropical
        
        public func degrees(for date:Date) -> Degree {
            switch self {
            case .galacticCenter:
                return galacticCenterOffset(for: date)
            default:
                return 0
            }
        }
        
        public func galacticCenterOffset(for date:Date) -> Degree {
            let thisTimeInterval = date.timeIntervalSince1970
            let ratio = thisTimeInterval / Ayanamsa.timeIntervalBetween
            let degreesOffset = Degree((Double(ratio) * Ayanamsa.galacticDegreesBetween) + Ayanamsa.degreesAt1970)
            return degreesOffset
        }
        
        public static let timeIntervalBetween:TimeInterval = {
            let startDate = Date(year: 1970, month: 1, day: 1, timeZone: TimeZone(secondsFromGMT: 0)!, hour: 1, minute: 1, second: 1)!
            let endDate = Date(year: 2070, month: 1, day: 1, timeZone: TimeZone(secondsFromGMT: 0)!, hour: 1, minute: 1, second: 1)!
            
            return endDate.timeIntervalSince(startDate)
        }()
        
        public static let galacticDegreesBetween:Double = {
            return degreesAt2070 - degreesAt1970
        }()
        
        public static let degreesAt1970:Double = 26.433333333333
        public static let degreesAt2070:Double = 27.833333333333
        
        
        public var rise:Degree? {
            return nil
        }
        
        public var fall:Degree? {
            return fall
        }
        
        public var exaltation:Degree? {
            return nil
        }
        
        public var debilitation:Degree? {
            return nil
        }
    }
}

