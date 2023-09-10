//
//  PlanetaryHarmonics.swift
//  Project2501
//
//  Created by Jordan Trana on 4/7/22.
//

import Foundation
import Combine
import SwiftAA


// MARK: Planetary Harmonics
public class PlanetaryHarmonics: ObservableObject {
    
    @Published var samples:[Date:HarmonicsSample] = [:]
    
    func calculateHarmonics(date: Date = Date(), coords: GeographicCoordinates = GeographicCoordinates(positivelyWestwardLongitude: -122, latitude: 47)) {
        
        /// Prevent Rewrites when the Sample has already been produced
        guard samples[date] == nil else {
            return
        }
        
        /// Get StarChart
        let starChart = StarChart(date: date,
                                  coordinates: coords,
                                  celestialOffset: .galacticCenter)
        
        /// Generate Normalized Sample
        var mergedSample = HarmonicsSample.empty
        for aspect in starChart.aspects {
            mergedSample.add(HarmonicsSample(aspect: aspect))
        }
        mergedSample.divide(starChart.aspects.count)
        
        samples[date] = mergedSample
    }
    
    var currentPlanetaryHarmonics: HarmonicsSample? {
        return getPlanetaryHarmonics(for: Date())
    }
    
    func getPlanetaryHarmonics(for selectedDate: Date) -> HarmonicsSample? {
        var timeIntervalSince:TimeInterval = TimeInterval.greatestFiniteMagnitude
        var closestDate: Date? = nil
        for (sampleDate,_) in samples {
            let newTimeIntervalSince = TimeInterval.minimum(timeIntervalSince, abs(selectedDate.timeIntervalSince(sampleDate)))
            if timeIntervalSince != newTimeIntervalSince {
                closestDate = sampleDate
                timeIntervalSince = newTimeIntervalSince
            }
        }
        if let date = closestDate {
            return samples[date]
        }
        return nil
    }
}

// MARK: Planetary Harmonics Sample
public extension PlanetaryHarmonics {
    struct HarmonicsSample {
        
        var octiveResonance: [HarmonicOctive:Double] = [:]
        
        var base1:Double {
            get { return octiveResonance[.base1] ?? 0 }
            set { octiveResonance[.base1] = newValue }
        }
        var base2:Double {
            get { return octiveResonance[.base2] ?? 0 }
            set { octiveResonance[.base2] = newValue }
        }
        var base3:Double {
            get { return octiveResonance[.base3] ?? 0 }
            set { octiveResonance[.base3] = newValue }
        }
        var base4:Double {
            get { return octiveResonance[.base4] ?? 0 }
            set { octiveResonance[.base4] = newValue }
        }
        var base5:Double {
            get { return octiveResonance[.base5] ?? 0 }
            set { octiveResonance[.base5] = newValue }
        }
        var base6:Double {
            get { return octiveResonance[.base6] ?? 0 }
            set { octiveResonance[.base6] = newValue }
        }
        var base7:Double {
            get { return octiveResonance[.base7] ?? 0 }
            set { octiveResonance[.base7] = newValue }
        }
        var base8:Double {
            get { return octiveResonance[.base8] ?? 0 }
            set { octiveResonance[.base8] = newValue }
        }
        var base9:Double {
            get { return octiveResonance[.base9] ?? 0 }
            set { octiveResonance[.base9] = newValue }
        }
        var base10:Double {
            get { return octiveResonance[.base10] ?? 0 }
            set { octiveResonance[.base10] = newValue }
        }
        var base11:Double {
            get { return octiveResonance[.base11] ?? 0 }
            set { octiveResonance[.base11] = newValue }
        }
        var base12:Double {
            get { return octiveResonance[.base12] ?? 0 }
            set { octiveResonance[.base12] = newValue }
        }
        
        public static var empty: HarmonicsSample { return HarmonicsSample() }
        private init() { }
        
        init(starChart: StarChart) {
            /// Generate Normalized Sample
            for aspect in starChart.aspects {
                add(HarmonicsSample(aspect: aspect))
            }
            divide(starChart.aspects.count)
        }
        
        init(aspect:CoreAstrology.Aspect) {
            self.base1 = (1 - sin(aspect.relation.nodeDistance.value * Double.pi / 180))
            self.base2 = sin(aspect.relation.nodeDistance.value * Double.pi / 180)
            self.base3 = sin(aspect.relation.nodeDistance.value * Double.pi / 120)
            self.base4 = sin(aspect.relation.nodeDistance.value * Double.pi / 90)
            self.base5 = sin(aspect.relation.nodeDistance.value * Double.pi / 72)
            self.base6 = sin(aspect.relation.nodeDistance.value * Double.pi / 60)
            self.base7 = sin(aspect.relation.nodeDistance.value * Double.pi / (1.0/7.0))
            self.base8 = sin(aspect.relation.nodeDistance.value * Double.pi / 45)
            self.base9 = sin(aspect.relation.nodeDistance.value * Double.pi / 40)
            self.base10 = sin(aspect.relation.nodeDistance.value * Double.pi / 36)
            self.base11 = sin(aspect.relation.nodeDistance.value * Double.pi / (1.0/11.0))
            self.base12 = sin(aspect.relation.nodeDistance.value * Double.pi / 30)
        }
        
        mutating func add(_ otherSample: HarmonicsSample) {
            self.base1 += otherSample.base1
            self.base2 += otherSample.base2
            self.base3 += otherSample.base3
            self.base4 += otherSample.base4
            self.base5 += otherSample.base5
            self.base6 += otherSample.base6
            self.base7 += otherSample.base7
            self.base8 += otherSample.base8
            self.base9 += otherSample.base9
            self.base10 += otherSample.base10
            self.base11 += otherSample.base11
            self.base12 += otherSample.base12
        }
        
        mutating func set(_ otherSample: HarmonicsSample) {
            self.base1 = otherSample.base1
            self.base2 = otherSample.base2
            self.base3 = otherSample.base3
            self.base4 = otherSample.base4
            self.base5 = otherSample.base5
            self.base6 = otherSample.base6
            self.base7 = otherSample.base7
            self.base8 = otherSample.base8
            self.base9 = otherSample.base9
            self.base10 = otherSample.base10
            self.base11 = otherSample.base11
            self.base12 = otherSample.base12
        }
        
        mutating func divide(_ amount: Int) {
            self.divide(Double(amount))
        }
        
        mutating func divide(_ amount: Double) {
            self.base1 /= amount
            self.base2 /= amount
            self.base3 /= amount
            self.base4 /= amount
            self.base5 /= amount
            self.base6 /= amount
            self.base7 /= amount
            self.base8 /= amount
            self.base9 /= amount
            self.base10 /= amount
            self.base11 /= amount
            self.base12 /= amount
        }
    }
}

// MARK: Planetary Harmonics Octive
public extension PlanetaryHarmonics {
    enum HarmonicOctive: Int, CaseIterable {
        case base1
        case base2
        case base3
        case base4
        case base5
        case base6
        case base7
        case base8
        case base9
        case base10
        case base11
        case base12
    }

}

