//
//  CosmicCypherTests.swift
//  CosmicCypherTests
//
//  Created by Jordan Trana on 10/21/20.
//

import XCTest
import SwiftAA
import TimeZoneLocate
import CoreLocation

@testable import ResonantFinder

class ResonantFinderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let coords = GeographicCoordinates(positivelyWestwardLongitude: 55, latitude: 55)
        
        let timezone = TimeZone(secondsFromGMT: 0)!
        var date = Date(year: 1970, month: 1, day: 1, timeZone: timezone, hour: 0, minute: 0)!
        let timestamp = Date()
        while date.timeIntervalSince1970 < timestamp.timeIntervalSince1970 {
            
            let starChart = StarChart(date: date, coords: coords)
            
            let asc = starChart.alignments[.ascendant]
            let midheaven = starChart.alignments[.midheaven]
            let sun = starChart.alignments[.sun]
            let jupiter = starChart.alignments[.jupiter]
            let venus = starChart.alignments[.venus]
            print("STARCHART:(\(date)")
            print("Sun: \(sun!.longitude)")
            print("ASC: \(asc!.longitude)")
            print("Midheaven: \(midheaven!.longitude)")
            print("meanLocalSiderealTime: \(starChart.date.julianDay.meanLocalSiderealTime(longitude: coords.longitude).inDegrees)\n")
            //print("Jupiter: \(jupiter!.longitude)")
            //print("Venus: \(venus!.longitude)")
            
            date = date.advanced(by: TimeInterval(60*60*24))
        }
    }
    
    func testPersonalBirthday() throws {
        let location = CLLocation(latitude: 39.8527302, longitude: 75.3442906)
        let coords = GeographicCoordinates(location)
        
        guard let timezone = TimeZoneLocate.timeZone(location: location),
              var date = Date(year: 1987, month: 4, day: 24, timeZone: timezone, hour: 6, minute: 43) else {XCTFail(); return;}
        
        let timestamp = Date()
        
        while date.timeIntervalSince1970 < timestamp.timeIntervalSince1970 {
            
            let starChart = StarChart(date: date, coords: coords)
            
            let asc = starChart.alignments[.ascendant]
            let midheaven = starChart.alignments[.midheaven]
            let sun = starChart.alignments[.sun]
            let jupiter = starChart.alignments[.jupiter]
            let venus = starChart.alignments[.venus]
            print("STARCHART:(\(date)")
            print("Sun: \(sun!.realLongitude)")
            print("ASC: \(asc!.realLongitude)")
            print("Midheaven: \(midheaven!.realLongitude)")
            print("meanLocalSiderealTime: \(starChart.date.julianDay.meanLocalSiderealTime(longitude: coords.longitude).inDegrees)\n")
            //print("Jupiter: \(jupiter!.longitude)")
            //print("Venus: \(venus!.longitude)")
            
            date = date.advanced(by: TimeInterval(60*60*24))
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
