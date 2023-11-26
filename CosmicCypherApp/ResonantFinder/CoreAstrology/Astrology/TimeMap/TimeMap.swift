//
//  TimeMap.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation

// MARK: Time Map
public class TimeMap: NSObject {
    
    // MARK: Properties
    // Time Window
    public var timeWindow:TimeWindow
    
    // Star Chart
    public var mainStarChart:StarChart? = nil
    
    
    // TimeStream Composites
    public var composites:[TimeStreamCompositeUUID:TimeStream.Composite]
    
    // Main Composite
    var mainComposite:TimeStream.Composite? {
        guard let uuid = mainCompositeUUID,
              let composite = composites[uuid] else {
            return nil
        }
        return composite
    }
    var mainCompositeUUID:TimeStreamCompositeUUID? = nil
    func composite(for uuid: TimeStreamCompositeUUID) -> TimeStream.Composite? {
        return composites[uuid]
    }
    
    // MARK: Init
    init(timeWindow: TimeWindow, composites: [TimeStreamCompositeUUID:TimeStream.Composite]? = nil) {
        self.timeWindow = timeWindow
        if let uuid = composites?.first?.value.uuid {
            mainCompositeUUID = uuid
        }
        self.composites = composites ?? [:]
    }
    
    // MARK: Accessors
    public var configuration:TimeStream.Configuration? {
        return mainComposite?.configuration
    }
    public var timeStream:TimeStream? {
        return mainComposite?.configuration.timeStreams.first
    }
    public var startDate:Date? {
        return configuration?.startDate
    }
    public var endDate:Date? {
        return configuration?.endDate
    }
    public var timeRange: Range<Date>? {
        if let start = startDate, let end = endDate {
            return start..<end
        }
        return nil
    }
    public var imageMap: TimeStream.Composite.ImageMap? {
        return mainComposite?.imageMap
    }
    public var spectrogram: TimeStreamSpectrogram? {
        return mainComposite?.spectrogram
    }
    public var resonanceScores: [StarChart.ResonanceScore]? {
        return mainComposite?.resonanceScores
    }
}
