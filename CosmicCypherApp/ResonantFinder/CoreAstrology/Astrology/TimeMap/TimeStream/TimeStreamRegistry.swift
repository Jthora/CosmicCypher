//
//  TimeStreamRegistry.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/6/22.
//

import Foundation
import UIKit
import SwiftAA

public typealias TimeStreamUUID = UUID
public typealias TimeStreamCache = [TimeStreamUUID:TimeStream]

public final class TimeStreamRegistry {
    
    public static let main:TimeStreamRegistry = TimeStreamRegistry()
    
    var cache:TimeStreamCache = TimeStreamCache()
    
    func preloadStoredTimeStreams() {
        // Too many...
    }
    
    func loadTimeStreamFromArchive(uuid:TimeStreamUUID) {
        if cache[uuid] == nil {
            Task {
                if let archivedTimeStream = try await TimeStreamArchive.main.fetch(uuid: uuid) {
                    cache[uuid] = archivedTimeStream
                }
            }
        }
    }
    
    func newTimeStream(startDate:Date, endDate:Date, geographicCoordinates:GeographicCoordinates) {
        print("❇️ New TimeStream")
        let uuid = TimeStreamUUID()
        if cache[uuid] == nil {
            let timeStream = TimeStream(uuid: uuid, startDate: startDate, endDate: endDate, coordinates: geographicCoordinates)
            Task {
                try await TimeStreamArchive.main.store(timestream: timeStream)
            }
            cache[timeStream.id] = timeStream
        }
    }
}
