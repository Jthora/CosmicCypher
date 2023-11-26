//
//  PlanetNodeStateArchive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/5/22.
//

import Foundation
import SwiftAA
import CoreData



// MARK: Planet Node State Archive
public final actor PlanetNodeStateArchive {
    
    // MARK: Singleton
    static let main: PlanetNodeStateArchive = PlanetNodeStateArchive()
    private init() {}
    
    static let entityName = "PlanetNodeState"
    static let entityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityName, in: DataCore.context)! }()
    static let entityTimelineName = "PlanetNodeStateTimeline"
    static let entityTimelineDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityTimelineName, in: DataCore.context)! }()
    
    // MARK: Store TimeStream Composite in Archive
    func store(planetNodeState: PlanetNodeState) async throws {
        try await DataCore.context.perform {
            
            // Create Fetch Request
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: PlanetNodeStateArchive.entityName)
            let predicate = NSPredicate(format: "%i == nodeType AND %i == subType AND %@ == date",planetNodeState.nodeType.rawValue, planetNodeState.nodeType.subType.rawValue, planetNodeState.date as NSDate)
            request.predicate = predicate
             
            // Set Managed PlanetNode
            let managedObject: ManagedPlanetNodeState
            if let fetchResults = try? DataCore.context.fetch(request) {
                if fetchResults.count != 0,
                   let mo = fetchResults[0] as? ManagedPlanetNodeState {
                    managedObject = mo
                } else {
                    managedObject = ManagedPlanetNodeState(entity: PlanetNodeStateArchive.entityDescription, insertInto: DataCore.context)
                }
            } else {
                managedObject = ManagedPlanetNodeState(entity: PlanetNodeStateArchive.entityDescription, insertInto: DataCore.context)
            }
            
            // Set Values
            managedObject.setValue(planetNodeState.date as NSDate, forKey: "date")
            managedObject.setValue(planetNodeState.nodeType.rawValue as Int, forKey: "nodeType")
            managedObject.setValue(planetNodeState.nodeType.subType.rawValue as Int, forKey: "subType")
            managedObject.setValue(try planetNodeState.rawData(), forKey: "dataBlob")
            
            // Save
            DataCore.save()
        }
    }
    
    func store(planetNodeStates: [PlanetNodeState]) async throws {
        for planetNodeState in planetNodeStates {
            try await store(planetNodeState: planetNodeState)
        }
    }
    
    
    // MARK: Fetch Planet Node State from Archive
    nonisolated func fetch(date: Date, nodeType:PlanetNodeType, subType: PlanetNodeSubType) -> PlanetNodeState? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PlanetNodeStateArchive.entityName)
        let predicate = NSPredicate(format: "%i == nodeType AND %i == subType AND %@ == date", nodeType.rawValue, subType.rawValue, date as NSDate)
        request.predicate = predicate
        do {
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("PlanetNodeStateArchive.fetch() Error: no fetch results")
                return nil
            }
            guard fetchResults.count != 0 else {
                print("PlanetNodeStateArchive.fetch() Error: fetch results empty")
                return nil
            }
            guard let managedObject = fetchResults[0] as? NSManagedObject else {
                print("PlanetNodeStateArchive.fetch() Error: missing managedObject")
                return nil
            }
            guard let managedPlanetNode = managedObject as? ManagedPlanetNodeState else {
                print("PlanetNodeStateArchive.fetch() Error: managedObject is not a ManagedPlanetNodeState")
                return nil
            }
            guard let rawData = managedPlanetNode.value(forKey: "dataBlob") as? Data else {
                print("PlanetNodeStateArchive.fetch() Error: rawData is not actually Data")
                return nil
            }
            return try PlanetNodeState.from(rawData)
        } catch let error {
            print("ERROR:: \(error)")
            return nil
        }
    }
}

//
//
//// MARK: PlanetState Timeline Archive
//public final actor PlanetStateArchive {
//    
//    // MARK: Singleton
//    static let main: PlanetStateArchive = PlanetStateArchive()
//    private init() {}
//    
//    static let entityName = "PlanetState"
//    static let entityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityName, in: DataCore.context)! }()
//    static let entityTimelineName = "PlanetStateTimeline"
//    static let entityTimelineDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityTimelineName, in: DataCore.context)! }()
//    
//    // MARK: Store TimeStream Composite in Archive
//    func store(planetState: PlanetState) async throws {
//        try await DataCore.context.perform {
//            
//            // Create Fetch Request
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: PlanetStateArchive.entityName)
//            let predicate = NSPredicate(format: "%i == nodeType AND %@ == date", planetState.nodeType.rawValue, planetState.date as NSDate)
//            request.predicate = predicate
//             
//            // Set Managed Planet
//            let managedObject: ManagedPlanetState
//            if let fetchResults = try? DataCore.context.fetch(request) {
//                if fetchResults.count != 0,
//                   let mo = fetchResults[0] as? ManagedPlanetState {
//                    managedObject = mo
//                } else {
//                    managedObject = ManagedPlanetState(entity: PlanetStateArchive.entityDescription, insertInto: DataCore.context)
//                }
//            } else {
//                managedObject = ManagedPlanetState(entity: PlanetStateArchive.entityDescription, insertInto: DataCore.context)
//            }
//            
//            // Set Values
//            managedObject.setValue(planetState.date as NSDate, forKey: "date")
//            managedObject.setValue(planetState.nodeType.rawValue as Int, forKey: "nodeType")
//            managedObject.setValue(try planetState.rawData(), forKey: "dataBlob")
//            
//            // Save
//            DataCore.save()
//        }
//    }
//    
//    func store(planetStates: [PlanetState]) async throws {
//        for planetState in planetStates {
//            try await store(planetState: planetState)
//        }
//    }
//    
//    
//    // MARK: Fetch PlanetState from Archive
//    nonisolated func fetch(date: Date, nodeType:AstrologicalNodeType) -> PlanetState? {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PlanetStateArchive.entityName)
//        let predicate = NSPredicate(format: "%i == nodeType AND %@ == date", nodeType.rawValue, date as NSDate)
//        request.predicate = predicate
//        do {
//            let fetchResults = try DataCore.context.fetch(request)
//            
//            guard fetchResults.count != 0 else {
//                //print("PlanetStateArchive.fetch() Error: fetch results empty")
//                return nil
//            }
//            guard let managedObject = fetchResults[0] as? NSManagedObject else {
//                print("PlanetStateArchive.fetch() Error: missing managedObject")
//                return nil
//            }
//            guard let managedPlanet = managedObject as? ManagedPlanetState else {
//                print("PlanetStateArchive.fetch() Error: managedObject is not a ManagedPlanetState")
//                return nil
//            }
//            guard let rawData = managedPlanet.value(forKey: "dataBlob") as? Data else {
//                print("PlanetStateArchive.fetch() Error: rawData is not actually Data")
//                return nil
//            }
//            return try PlanetState.from(rawData)
//        } catch let error {
//            print("ERROR:: \(error)")
//            return nil
//        }
//    }
//}

//
//
//public typealias PlanetStateTimelineHash = Int
//extension PlanetStateTimelineHash {
//    init(path: TimeStream.Path, planets:[CoreAstrology.AspectBody.NodeType]) {
//        var hash = Hasher()
//        hash.combine(path)
//        hash.combine(planets)
//        self = hash.finalize()
//    }
//}

