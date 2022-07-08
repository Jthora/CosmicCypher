//
//  AstrologicalNodeStateArchive.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/5/22.
//

import Foundation
import SwiftAA
import CoreData

// MARK: AstrologicalNodeState Archive
public final actor AstrologicalNodeStateArchive {
    
    // MARK: Singleton
    static let main: AstrologicalNodeStateArchive = AstrologicalNodeStateArchive()
    private init() {}
    
    static let entityName = "AstrologicalNodeState"
    static let entityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityName, in: DataCore.context)! }()
    static let entityTimelineName = "AstrologicalNodeStateTimeline"
    static let entityTimelineDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityTimelineName, in: DataCore.context)! }()
    
    // MARK: Store TimeStream Composite in Archive
    func store(astrologicalNodeState: AstrologicalNodeState) async throws {
        try await DataCore.context.perform {
            
            // Create Fetch Request
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: AstrologicalNodeStateArchive.entityName)
            let predicate = NSPredicate(format: "%i == nodeType AND %i == subType AND %@ == date",astrologicalNodeState.nodeType.rawValue, astrologicalNodeState.subType.rawValue, astrologicalNodeState.date as NSDate)
            request.predicate = predicate
             
            // Set Managed AstrologicalNode
            let managedObject: ManagedAstrologicalNodeState
            if let fetchResults = try? DataCore.context.fetch(request) {
                if fetchResults.count != 0,
                   let mo = fetchResults[0] as? ManagedAstrologicalNodeState {
                    managedObject = mo
                } else {
                    managedObject = ManagedAstrologicalNodeState(entity: AstrologicalNodeStateArchive.entityDescription, insertInto: DataCore.context)
                }
            } else {
                managedObject = ManagedAstrologicalNodeState(entity: AstrologicalNodeStateArchive.entityDescription, insertInto: DataCore.context)
            }
            
            // Set Values
            managedObject.setValue(astrologicalNodeState.date as NSDate, forKey: "date")
            managedObject.setValue(astrologicalNodeState.nodeType.rawValue as Int, forKey: "nodeType")
            managedObject.setValue(astrologicalNodeState.subType.rawValue as Int, forKey: "subType")
            managedObject.setValue(try astrologicalNodeState.codable().rawData(), forKey: "dataBlob")
            
            // Save
            DataCore.save()
        }
    }
    
    func store(astrologicalNodeStates: [AstrologicalNodeState]) async throws {
        for astrologicalNodeState in astrologicalNodeStates {
            try await store(astrologicalNodeState: astrologicalNodeState)
        }
    }
    
    
    // MARK: Fetch AstrologicalNodeState from Archive
    nonisolated func fetch(date: Date, nodeType:AstrologicalNodeType, subType: AstrologicalNodeSubType) -> AstrologicalNodeState? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AstrologicalNodeStateArchive.entityName)
        let predicate = NSPredicate(format: "%i == nodeType AND %i == subType AND %@ == date", nodeType.rawValue, subType.rawValue, date as NSDate)
        request.predicate = predicate
        do {
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("AstrologicalNodeStateArchive.fetch() Error: no fetch results")
                return nil
            }
            guard fetchResults.count != 0 else {
                print("AstrologicalNodeStateArchive.fetch() Error: fetch results empty")
                return nil
            }
            guard let managedObject = fetchResults[0] as? NSManagedObject else {
                print("AstrologicalNodeStateArchive.fetch() Error: missing managedObject")
                return nil
            }
            guard let managedAstrologicalNode = managedObject as? ManagedAstrologicalNodeState else {
                print("AstrologicalNodeStateArchive.fetch() Error: managedObject is not a ManagedAstrologicalNodeState")
                return nil
            }
            guard let rawData = managedAstrologicalNode.value(forKey: "dataBlob") as? Data else {
                print("AstrologicalNodeStateArchive.fetch() Error: rawData is not actually Data")
                return nil
            }
            return try CodableAstrologicalNodeState.from(rawData)
        } catch let error {
            print("ERROR:: \(error)")
            return nil
        }
    }
}
