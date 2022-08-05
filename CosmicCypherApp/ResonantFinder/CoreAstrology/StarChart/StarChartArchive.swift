//
//  StarChartArchive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/7/22.
//

import Foundation
import SwiftAA
import CoreData


// MARK: StarChart Archive
public final actor StarChartArchive {
    
    // MARK: Singleton
    static let main: StarChartArchive = StarChartArchive()
    private init() {}
    
    static let entityName = "StarChart"
    static let entityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityName, in: DataCore.context)! }()
    
    // MARK: Store TimeStream Composite in Archive
    func store(starChart: StarChart) async throws {
        try await DataCore.context.perform {
            
            // Create Fetch Request
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: StarChartArchive.entityName)
            let predicate = NSPredicate(format: "%d == longitude AND %d == latitude AND %d == altitude AND %@ == date", starChart.coordinates.longitude.value, starChart.coordinates.latitude.value, starChart.coordinates.altitude.value, starChart.date as NSDate)
            request.predicate = predicate
             
            // Set Managed StarChart
            let managedObject: ManagedStarChart
            if let fetchResults = try? DataCore.context.fetch(request) {
                if fetchResults.count != 0,
                   let mo = fetchResults[0] as? ManagedStarChart {
                    managedObject = mo
                } else {
                    managedObject = ManagedStarChart(entity: StarChartArchive.entityDescription, insertInto: DataCore.context)
                }
            } else {
                managedObject = ManagedStarChart(entity: StarChartArchive.entityDescription, insertInto: DataCore.context)
            }
            
            // Set Values
            managedObject.setValue(starChart.coordinates.longitude.value, forKey: "longitude")
            managedObject.setValue(starChart.coordinates.latitude.value, forKey: "latitude")
            managedObject.setValue(starChart.coordinates.altitude.value, forKey: "altitude")
            managedObject.setValue(starChart.date as NSDate, forKey: "date")
            managedObject.setValue(try starChart.rawData(), forKey: "dataBlob")
            
            // Save
            DataCore.save()
        }
    }
    
    func store(starCharts: [StarChart]) async throws {
        for starChart in starCharts {
            try await store(starChart: starChart)
        }
    }
    
    
    // MARK: Fetch StarChart from Archive
    nonisolated func fetch(date: Date, geographicCoordinates: GeographicCoordinates) -> StarChart? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: StarChartArchive.entityName)
        let predicate = NSPredicate(format: "%d == longitude AND %d == latitude AND %d == altitude AND %@ == date", geographicCoordinates.longitude.value, geographicCoordinates.latitude.value, geographicCoordinates.altitude.value, date as NSDate)
        request.predicate = predicate
        do {
            let fetchResults = try DataCore.context.fetch(request)
            
            guard fetchResults.count != 0 else {
                print("StarChartArchive.fetch() Error: fetch results empty")
                return nil
            }
            guard let managedObject = fetchResults[0] as? NSManagedObject else {
                print("StarChartArchive.fetch() Error: missing managedObject")
                return nil
            }
            guard let managedStarChart = managedObject as? ManagedStarChart else {
                print("StarChartArchive.fetch() Error: managedObject is not a ManagedStarChart")
                return nil
            }
            guard let rawData = managedStarChart.value(forKey: "dataBlob") as? Data else {
                print("StarChartArchive.fetch() Error: rawData is not actually Data")
                return nil
            }
            return try? StarChart.from(rawData)
        } catch let error {
            print("ERROR:: \(error)")
            return nil
        }
    }
}
