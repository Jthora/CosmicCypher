//
//  TimeStreamArchive.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/6/22.
//

import Foundation
import SwiftAA
import CoreData

//// MARK: TimeStream Hash
//public typealias TimeStreamHash = Int
//extension TimeStreamHash {
//    init(path:TimeStream.Path, dateRange:Range<Date>) {
//        var hasher = Hasher()
//        hasher.combine(path)
//        self = hasher.finalize()
//    }
//    init(path:TimeStream.Path) {
//        var hasher = Hasher()
//        hasher.combine(path)
//        self = hasher.finalize()
//    }
//}

// MARK: TimeStream Archive
public final class TimeStreamArchive {
    
    // MARK: Singleton
    static let main: TimeStreamArchive = TimeStreamArchive()
    private init() {}
    
    // MARK: ManagedObject Entity Name & Description
    static let entityName = "TimeStream"
    static let entityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityName, in: DataCore.context)! }()
    
    // MARK: Store TimeStream in Archive
    func store(timestream: TimeStream) async throws {
        try await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamArchive.entityName)
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamCompositeArchive.fetch() Error: no fetch results")
                return
            }
            guard fetchResults.count != 0 else {
                print("TimeStreamCompositeArchive.fetch() Error: fetch results empty")
                return
            }
            guard let managedObject = fetchResults[0] as? ManagedTimeStream else {
                print("TimeStreamCompositeArchive.fetch() Error: missing managedObject")
                return
            }
            managedObject.setValue(timestream.id, forKey: "uuid")
            DataCore.save()
        }
    }
    
    // MARK: Fetch TimeStream from Archive
    func fetch(uuid: UUID) async throws -> TimeStream? {
        try await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamArchive.entityName)

            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamArchive.fetch() Error: no fetch results")
                return nil
            }
            guard fetchResults.count != 0 else {
                print("TimeStreamArchive.fetch() Error: fetch results empty")
                return nil
            }
            guard let managedObject = fetchResults[0] as? ManagedTimeStream else {
                print("TimeStreamArchive.fetch() Error: missing managedObject")
                return nil
            }
            guard let rawData = managedObject.value(forKey: "dataBlob") as? Data else {
                print("TimeStreamArchive.fetch() Error: managedObject is not a ManagedStarChart")
                return nil
            }
            return try TimeStream.from(rawData)
        }
    }
}
