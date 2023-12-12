//
//  StarChartTest.swift
//  CosmicCypherTests
//
//  Created by Jordan Trana on 11/28/20.
//

import XCTest
import SwiftAA
import TimeZoneLocate
import CoreLocation

@testable import CosmicCypher

class StarChartTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCosmicAlignment() throws {
        let location = CLLocation(latitude: 39.8527302, longitude: 75.3442906)
        guard let timezone = TimeZoneLocate.timeZone(location: location),
              let date = Date(year: 1987, month: 4, day: 24, timeZone: timezone, hour: 6, minute: 43, second: 1) else {XCTFail(); return;}
        let starChart = StarChart(date: date)
        let cosmicAlignment = starChart.cosmicAlignment(selectedPlanets: DEFAULT_SELECTED_PLANETS)
        print(cosmicAlignment)
    }
}
