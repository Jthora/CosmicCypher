//
//  TimeStreamCompositeArchive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/8/22.
//

import Foundation
import SwiftAA
import CoreData

// MARK: TimeStream Composite Hash
public typealias TimeStreamCompositeUUID = UUID

extension TimeStreamCompositeArchive {
    public typealias UUIDList = [TimeStreamCompositeUUID]
}
extension TimeStreamCompositeArchive.UUIDList {
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) -> TimeStreamCompositeArchive.UUIDList? { return try? JSONDecoder().decode(TimeStreamCompositeArchive.UUIDList.self, from: rawData) }
}

// MARK: TimeStream Composite Archive
public final actor TimeStreamCompositeArchive {
    
    // MARK: Singleton
    static let main: TimeStreamCompositeArchive = TimeStreamCompositeArchive()
    private init() {}
    
    // MARK: ManagedObject Entity Names & Descriptions
    static let entityName = "TimeStreamComposite"
    static let uuidKey = "uuid"
    static let dataBlobKey = "dataBlob"
    static let entityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: entityName, in: DataCore.context)! }()
    
    static let uuidListEntityName = "UUIDList"
    static let uuidListEntityKey = "dataBlob"
    static let uuidListEntityDescription: NSEntityDescription = { return NSEntityDescription.entity(forEntityName: uuidListEntityName, in: DataCore.context)! }()
    
    // MARK: Store TimeStream Composite in Archive
    func store(composite: TimeStream.Composite) async throws {
        try await store(uuid: composite.uuid)
        try await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamCompositeArchive.entityName)
            //let predicate = NSPredicate(format: "idHash = %i", composite.hashValue)
            let predicate = NSPredicate(format: "%K == %@", #keyPath(TimeStream.Composite.uuid), composite.uuid as NSUUID)
            request.predicate = predicate

            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamCompositeArchive.store(composite) Error: no fetch results")
                return
            }
            
            let managedObject: ManagedTimeStreamComposite
            if let mo = fetchResults.first as? ManagedTimeStreamComposite {
                // Update
                managedObject = mo
            } else {
                // New
                managedObject = ManagedTimeStreamComposite(entity: TimeStreamCompositeArchive.entityDescription, insertInto: DataCore.context)
            }
            managedObject.setValue(composite.uuid, forKey: TimeStreamCompositeArchive.uuidKey )
            managedObject.setValue(try composite.rawData(), forKey: TimeStreamCompositeArchive.dataBlobKey )
            DataCore.save()
        }
    }
    
    // MARK: Store UUID into HashList
    func store(uuid:TimeStreamCompositeUUID) async throws {
        try await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamCompositeArchive.uuidListEntityName)
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamCompositeArchive.store(uuid) Error: no fetch results")
                return
            }
            
            let managedObject: ManagedUUIDList
            let rawData: Data
            if fetchResults.count != 0,
               let mo = fetchResults[0] as? ManagedUUIDList,
               let rd = mo.value(forKey: TimeStreamCompositeArchive.uuidListEntityKey) as? Data {
                managedObject = mo
                guard var archivedHashList = UUIDList.from(rd) else {
                    print("TimeStreamCompositeArchive.store(uuid) Error: rawData not a UUIDList")
                    return
                }
                guard !archivedHashList.contains(uuid) else {
                    print("TimeStreamCompositeArchive.store(uuid) uuid Already Stored: \(uuid)")
                    return
                }
                archivedHashList.append(uuid)
                rawData = try archivedHashList.rawData()
            } else {
                managedObject = ManagedUUIDList(entity: TimeStreamCompositeArchive.uuidListEntityDescription, insertInto: DataCore.context)
                var newUUIDList = UUIDList()
                print("Created New UUIDList")
                newUUIDList.append(uuid)
                rawData = try newUUIDList.rawData()
            }
            managedObject.setValue(rawData, forKey: TimeStreamCompositeArchive.uuidListEntityKey )
            DataCore.save()
            print("store [\(uuid.uuidString)]")
        }
    }
    
    // MARK: Store Hash into HashList
    func delete(uuid:TimeStreamCompositeUUID) async {
        await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamCompositeArchive.uuidListEntityName)
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamCompositeArchive.delete(hash) Error: no fetch results")
                return
            }
            guard fetchResults.count != 0 else {
                print("TimeStreamCompositeArchive.delete(hash) Error: fetch results empty")
                return
            }
            guard let managedObject = fetchResults[0] as? ManagedTimeStream else {
                print("TimeStreamCompositeArchive.delete(hash) Error: missing managedObject")
                return
            }
            guard let rawData = managedObject.value(forKey: TimeStreamCompositeArchive.uuidListEntityKey) as? Data else {
                print("TimeStreamCompositeArchive.delete(hash) Error: managedObject is not a ManagedHashList")
                return
            }
            guard var archivedHashList = UUIDList.from(rawData) else {
                print("TimeStreamCompositeArchive.delete(hash) Error: rawData not a HashList")
                return
            }
            archivedHashList.removeAll { $0 == uuid }
            managedObject.setValue(archivedHashList, forKey: "dataBlob")
            DataCore.save()
        }
    }
    
    // MARK: Fetch Hash List of All TimeStream Composites
    func fetchUUIDList() async throws -> UUIDList {
        var uuidList:UUIDList? = nil
        await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamCompositeArchive.uuidListEntityName)
            
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamCompositeArchive.fetchUUIDList() Error: no fetch results")
                return
            }
            guard fetchResults.count != 0 else {
                print("TimeStreamCompositeArchive.fetchUUIDList() Error: fetch results empty")
                return
            }
            guard let managedObject = fetchResults[0] as? ManagedUUIDList else {
                print("TimeStreamCompositeArchive.fetchUUIDList() Error: missing managedObject")
                return
            }
            guard let rawData = managedObject.dataBlob else {
                print("TimeStreamCompositeArchive.fetchUUIDList() Error: dataBlob doesn't exist")
                return
            }
            guard let archivedUUIDList = UUIDList.from(rawData) else {
                print("TimeStreamCompositeArchive.fetchUUIDList() Error: rawData not a UUIDList")
                return
            }
            uuidList = archivedUUIDList
        }
        
        if let uuidList = uuidList {
            return uuidList
        } else {
            print("Creating New UUIDList")
            let uuidList = UUIDList()
            try await store(uuidList: uuidList)
            return uuidList
        }
        
    }
    
    func store(uuidList:UUIDList) async throws {
        try await DataCore.context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamCompositeArchive.uuidListEntityName)
            
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                print("TimeStreamCompositeArchive.store(uuidList) Error: no fetch results")
                return
            }
            
            let managedObject: ManagedUUIDList
            let rawData: Data
            if fetchResults.count != 0,
               let mo = fetchResults[0] as? ManagedUUIDList {
                managedObject = mo
            } else {
                managedObject = ManagedUUIDList(entity: TimeStreamCompositeArchive.uuidListEntityDescription, insertInto: DataCore.context)
                
            }
            
            rawData = try uuidList.rawData()
            managedObject.setValue(rawData, forKey: TimeStreamCompositeArchive.uuidListEntityKey )
            DataCore.save()
        }
    }
        
    // MARK: Fetch All TimeStream Composites from Archive
    func fetchAll() async throws -> TimeStreamCompositeCache {
        var composites = TimeStreamCompositeCache()
        let uuidList = try await fetchUUIDList()
        for uuid in uuidList {
            guard let composite = try await self.fetch(uuid: uuid) else {
                throw NSError(domain: "TimeStream Composite not found for hash: \(uuid)", code: -1, userInfo: nil)
            }
            composites[uuid] = composite
        }
        return composites
    }
    
        
    // MARK: Fetch a TimeStream Composite from Archive
    func fetch(uuid: TimeStreamCompositeUUID) async throws -> TimeStream.Composite? {
        try await DataCore.context.perform {
            let timeStamp = Date()
            DispatchQueue.main.async {
                print("Preload: uuid: \(uuid) -- timestamp: [\(timeStamp)]")
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: TimeStreamCompositeArchive.entityName)
            //let predicate = NSPredicate(format: "idHash = %i", composite.hashValue)
            let predicate = NSPredicate(format: "%K == %@", #keyPath(TimeStream.Composite.uuid), uuid as NSUUID)
            request.predicate = predicate
            DispatchQueue.main.async {
                print("Preload: extracting fetchResults [\(timeStamp.timeIntervalSinceNow)]")
            }
            guard let fetchResults = try? DataCore.context.fetch(request) else {
                DispatchQueue.main.async {
                    print("TimeStreamCompositeArchive.fetch(uuid) Error: no fetch results")
                }
                return nil
            }
            DispatchQueue.main.async {
                print("Preload: extracting ManagedTimeStreamComposite [\(timeStamp.timeIntervalSinceNow)]")
            }
            guard let managedObject = fetchResults.first as? ManagedTimeStreamComposite else {
                DispatchQueue.main.async {
                    print("TimeStreamCompositeArchive.fetch(uuid) Error: fetch results aren't ManagedTimeStreamComposite")
                }
                return nil
            }
            DispatchQueue.main.async {
                print("Preload: extracting rawData from dataBlob [\(timeStamp.timeIntervalSinceNow)]")
            }
            guard let rawData = managedObject.dataBlob else {
                DispatchQueue.main.async {
                    print("TimeStreamCompositeArchive.fetch(uuid) Error: dataBlob doesn't exist")
                }
                return nil
            }
            DispatchQueue.main.async {
                print("Preload: converting rawData to composite [\(timeStamp.timeIntervalSinceNow)]")
            }
            guard let composite = try? TimeStream.Composite.from(rawData: rawData) else {
                DispatchQueue.main.async {
                    print("TimeStreamCompositeArchive.fetch(uuid) Error: rawData not a HashList")
                }
                return nil
            }
            DispatchQueue.main.async {
                print("Preload: returning composite [\(timeStamp.timeIntervalSinceNow)]")
            }
            return composite
        }
    }
}
