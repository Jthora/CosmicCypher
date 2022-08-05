//
//  TimeStreamCompositeRegistry.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/2/22.
//

import Foundation
import SwiftAA

public typealias TimeStreamCompositeCache = [TimeStreamCompositeUUID:TimeStream.Composite]

public final class TimeStreamCompositeRegistry: ObservableObject {
    
    public static let main:TimeStreamCompositeRegistry = TimeStreamCompositeRegistry()
    
    private init() {}
    
    @Published var uuidList = TimeStreamCompositeArchive.UUIDList()
    @Published var cache = TimeStreamCompositeCache()
    
    let queue = DispatchQueue(label: "TimeStreamCompositeRegistryDispatchQueue")
    
    func reload(onComplete:(()->())? = nil) {
        print("reloading...")
        queue.async {
            Task {
                self.uuidList = try await TimeStreamCompositeArchive.main.fetchUUIDList()
                for uuid in self.uuidList {
                    print("attempt archive fetch: \(uuid)")
                    self.cache[uuid] = try await TimeStreamCompositeArchive.main.fetch(uuid: uuid)
                }
                onComplete?()
            }
        }
    }
    
    func load(uuid:TimeStreamCompositeUUID, onComplete:(()->())? = nil) {
        print("load composite [\(uuid.uuidString)]")
        if cache[uuid] == nil {
            queue.async {
                Task {
                    self.cache[uuid] = try await TimeStreamCompositeArchive.main.fetch(uuid: uuid)
                    onComplete?()
                }
            }
        }
    }
    
    func save(composite: TimeStream.Composite, onComplete:(()->())? = nil) {
        print("save composite [\(composite.uuid.uuidString)]")
        cache[composite.uuid] = composite
        if uuidList.contains(composite.uuid) == false {
            uuidList.append(composite.uuid)
        }
        queue.async {
            Task {
                try await TimeStreamCompositeArchive.main.store(composite: composite)
                onComplete?()
            }
        }
    }
    
    func remove(composite: TimeStream.Composite, onComplete:(()->())? = nil) {
        print("remove composite [\(composite.uuid.uuidString)]")
        queue.async {
            Task {
                await TimeStreamCompositeArchive.main.delete(uuid: composite.uuid)
                onComplete?()
            }
        }
    }
}
