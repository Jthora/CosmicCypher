//
//  Date+Extension.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/7/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA
import CoreLocation


extension Date {
    
//    var year: Int? {
//        return Calendar.current.dateComponents([.year], from: self).year
//    }
    
    static func getWeekOfYear(from week: Int, year: Int? = Date().year, locale: Locale? = nil) -> Date? {
        var calendar = Calendar.current
        calendar.locale = locale
        let dateComponents = DateComponents(calendar: calendar, year: year, weekday: 1, weekOfYear: week)
        return calendar.date(from: dateComponents)
    }
    
    
    // Daytime
    var hour:Int { return hour() }
    func hour(timeZone:TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.component(.hour, from: self)
    }
    var minute:Int { return minute() }
    func minute(timeZone:TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.component(.minute, from: self)
    }
    var second:Int {
        return Calendar.current.component(.second, from: self)
    }
    var fractionOfDay:Float {
        return (Float(hour) + (Float(minute)/60.0) + (Float(second)/3600.0)) / 24.0
    }
    
    // Start Of
    var startOfWeek: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .weekOfMonth, for: self)?.start
    }

    var endOfWeek: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .weekOfMonth, for: self)?.end
    }
    
    var startOfMonth: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .month, for: self)?.start
    }

    var endOfMonth: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .month, for: self)?.end
    }
    
    var startOfYear: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .year, for: self)?.start
    }

    var endOfYear: Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .year, for: self)?.end
    }

    var weekNumber: Int? {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.weekOfYear], from: self)
        return currentComponents.weekOfYear
    }

    var monthNumber: Int? {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.month], from: self)
        return currentComponents.month
    }
    
    //Yeartime
    var daysThisYear:Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self) ?? 1
    }
    var fractionOfYear:Float {
        return Float(daysThisYear) / 365.0
    }
    var fractionAfterWinterSolstice:Float {
        return Float(daysThisYear+10).truncatingRemainder(dividingBy: 365) / 365.0
    }
    
    func resetTime(timedate:Date) -> Date {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        var resultdate = Date()
        if let dateFromString = df.date(from: df.string(from: self)) {
            
            let hour = NSCalendar.current.component(.hour, from: timedate)
            let minutes = NSCalendar.current.component(.minute, from: timedate)
            if let dateFromStringWithTime = NSCalendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: dateFromString) {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS'Z"
                let resultString = df.string(from: dateFromStringWithTime)
                resultdate = df.date(from: resultString)!
            }
        }
        return resultdate
    }
    
    
}

extension Date {
    
    var beginningOfDay: Date {
        return Date.beginningOf(.date(self))!
    }
    
    enum BeginningOfOption {
        
        case date(_ date:Date)
        
        case yesterday
        case today
        case tomorrow
        
        case thisWeek
        case thisMonth
        case thisYear
        
        case nextWeek
        case nextMonth
        case nextYear
        
        case dayAfterToday(_ daysAfter:UInt)
        case dayBeforeToday(_ daysBefore:UInt)
        case year(_ yearInt:Int)
    }
    
    enum EndOfOption {
        
        case date(_ date:Date)
        
        case yesterday
        case today
        case tomorrow
        
        case thisWeek
        case thisMonth
        case thisYear
        
        case nextWeek
        case nextMonth
        case nextYear
        
        case dayAfterToday(_ daysAfter:UInt)
        case dayBeforeToday(_ daysBefore:UInt)
        case year(_ yearInt:Int)
    }
    
    static func endOf(_ option:EndOfOption, timeZone:TimeZone? = nil) -> Date? {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let today: Date
        switch option {
        case .date(let date):
            today = date
        default:
            today = Date()
        }
        
        let midnight = calendar.startOfDay(for: today)
        let oneSecondBeforeMidnight = Date(year: midnight.year, month: midnight.month, day: midnight.day, timeZone: calendar.timeZone, hour: 23, minute: 59, second: 59)!
        
        switch option {
        case .date:
            return oneSecondBeforeMidnight
        case .yesterday:
            return calendar.date(byAdding: .day, value: -1, to: midnight)
        case .today:
            return oneSecondBeforeMidnight
        case .tomorrow:
            return calendar.date(byAdding: .day, value: 1, to: midnight)
        case .thisWeek:
            return today.startOfWeek
        case .thisMonth:
            return calendar.date(from: DateComponents(month: today.month))
        case .thisYear:
            return calendar.date(from: DateComponents(year: today.year))
        case .nextWeek:
            guard let startOfWeek = today.startOfWeek else {
                return nil
            }
            return calendar.date(byAdding: .day, value: 7, to: startOfWeek)
        case .nextMonth:
            guard let firstDayOfThisMonth = calendar.date(from: DateComponents(month: today.month)) else {
                return nil
            }
            return calendar.date(byAdding: .month, value: 1, to: firstDayOfThisMonth)
        case .nextYear:
            guard let firstDayOfThisYear = calendar.date(from: DateComponents(year: today.year)) else {
                return nil
            }
            return calendar.date(byAdding: .year, value: 1, to: firstDayOfThisYear)
        case .dayAfterToday(let daysAfter):
            guard let daysAfter = Int(exactly: daysAfter) else {
                return nil
            }
            return calendar.date(byAdding: .day, value: daysAfter, to: oneSecondBeforeMidnight)
        case .dayBeforeToday(let daysBefore):
            guard let daysBefore = Int(exactly: daysBefore) else {
                return nil
            }
            return calendar.date(byAdding: .day, value: -daysBefore, to: oneSecondBeforeMidnight)
        case .year(let yearInt):
            return calendar.date(from: DateComponents(year: yearInt))
        }
        
    }
    
    static func beginningOf(_ option:BeginningOfOption, timeZone:TimeZone? = nil) -> Date? {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        
        switch option {
        case .date(let date):
            return calendar.startOfDay(for: date)
        case .yesterday:
            return calendar.date(byAdding: .day, value: -1, to: midnight)
        case .today:
            return midnight
        case .tomorrow:
            return calendar.date(byAdding: .day, value: 1, to: midnight)
        case .thisWeek:
            return today.startOfWeek
        case .thisMonth:
            return calendar.date(from: DateComponents(month: today.month))
        case .thisYear:
            return calendar.date(from: DateComponents(year: today.year))
        case .nextWeek:
            guard let startOfWeek = today.startOfWeek else {
                return nil
            }
            return calendar.date(byAdding: .day, value: 7, to: startOfWeek)
        case .nextMonth:
            guard let firstDayOfThisMonth = calendar.date(from: DateComponents(month: today.month)) else {
                return nil
            }
            return calendar.date(byAdding: .month, value: 1, to: firstDayOfThisMonth)
        case .nextYear:
            guard let firstDayOfThisYear = calendar.date(from: DateComponents(year: today.year)) else {
                return nil
            }
            return calendar.date(byAdding: .year, value: 1, to: firstDayOfThisYear)
        case .dayAfterToday(let daysAfter):
            guard let daysAfter = Int(exactly: daysAfter) else {
                return nil
            }
            return calendar.date(byAdding: .day, value: daysAfter, to: midnight)
        case .dayBeforeToday(let daysBefore):
            guard let daysBefore = Int(exactly: daysBefore) else {
                return nil
            }
            return calendar.date(byAdding: .day, value: -daysBefore, to: midnight)
        case .year(let yearInt):
            return calendar.date(from: DateComponents(year: yearInt))
        }
    }
    
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}

extension Date {
    func formattedTime(for coordinates: GeographicCoordinates) -> String {
        var calendar = Calendar.current
        var timeZone:TimeZone? = nil
        #if !targetEnvironment(macCatalyst)
        timeZone = coordinates.location.timeZone
        calendar.timeZone = timeZone
        #endif
        let abbreviation = timeZone?.abbreviation() ?? "Unknown TimeZone"
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let second = calendar.component(.second, from: self)
        
        let hourString = String(format: "%02d", hour)
        let minuteString = String(format: "%02d", minute)
        let secondString = String(format: "%02d", second)
        
        return "\(hourString):\(minuteString):\(secondString) [\(abbreviation)]"
    }
}

