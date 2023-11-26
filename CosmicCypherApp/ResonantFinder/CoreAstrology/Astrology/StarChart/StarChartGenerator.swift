//
//  StarChartGenerator.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 9/26/21.
//

import Foundation
import SwiftAA

open class StarChartGenerator {
    
    public static let defaultGeographicCoordinates = GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0)
    
    public static func generate(from startDate:Date, to endDate:Date, at coordinates:GeographicCoordinates = defaultGeographicCoordinates, sampleCount:UInt) -> [StarChart] {
        var starCharts:[StarChart] = []
        guard sampleCount > 2 else { return starCharts }
        
        let totalTime:TimeInterval = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        let timeStep = totalTime/TimeInterval(sampleCount)
        
        for i in 0...sampleCount {
            let timeOffset = timeStep * TimeInterval(i)
            let offsetDate = Date(timeIntervalSince1970: startDate.timeIntervalSince1970 + timeOffset)
            let starChart = StarChart(date: offsetDate, coordinates: coordinates, celestialOffset: .galacticCenter) // ⚠️ Always use Galactic Center Sidereal Astrology!
            starCharts.append(starChart)
        }
        
        return starCharts
    }
    
    
    public static func generate(from startDate:Date, to endDate:Date, at coordinates:GeographicCoordinates = defaultGeographicCoordinates, calendarComponent:Calendar.Component = .day, includeFinalDate:Bool = false) -> [StarChart] {
        
        var starCharts:[StarChart] = []
        guard startDate < endDate else { return starCharts }
        
        var currentDate:Date = startDate
        while currentDate < endDate {
            starCharts.append(StarChart(date: currentDate, coordinates: coordinates, celestialOffset: .galacticCenter)) // ⚠️ Always use Galactic Center Sidereal Astrology!
            currentDate = Calendar.current.date(byAdding: calendarComponent, value: 1, to: currentDate)!
        }
        
        if includeFinalDate {
            starCharts.append(StarChart(date: endDate, coordinates: coordinates, celestialOffset: .galacticCenter)) // ⚠️ Always use Galactic Center Sidereal Astrology!
        }
        
        return starCharts
    }
    
    
    public static func generate(from startDate:Date, to endDate:Date, at coordinates:GeographicCoordinates = defaultGeographicCoordinates, interval:TimeInterval) -> [StarChart] {
        var starCharts:[StarChart] = []
        
        let totalTime:TimeInterval = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        let sampleCount = UInt(abs(totalTime/interval))
        
        for i in 0...sampleCount {
            let timeOffset = interval * TimeInterval(i)
            let offsetDate = Date(timeIntervalSince1970: startDate.timeIntervalSince1970 + timeOffset)
            let starChart = StarChart(date: offsetDate, coordinates: coordinates, celestialOffset: .galacticCenter) // ⚠️ Always use Galactic Center Sidereal Astrology!
            starCharts.append(starChart)
        }
        
        return starCharts
    }
}
