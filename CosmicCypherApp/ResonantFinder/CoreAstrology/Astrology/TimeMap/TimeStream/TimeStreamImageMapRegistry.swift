//
//  TimeStreamImageMapRegistry.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/3/22.
//

import Foundation


import Foundation
import SwiftAA

public typealias TimeStreamImageMapCache = [TimeStreamImageMapUUID:TimeStream.Composite.ImageMap]

public final class TimeStreamImageMapRegistry: ObservableObject {
    
    public static let main:TimeStreamImageMapRegistry = TimeStreamImageMapRegistry()
    
    private init() {}
    
    @Published var uuidList = TimeStreamCompositeArchive.UUIDList()
    @Published var cache = TimeStreamImageMapCache()
    
    func reload(onComplete:(()->())? = nil) {
        print("preloading...")
        Task {
            cache = try await TimeStreamImageMapArchive.main.fetchAll()
            uuidList = try await TimeStreamCompositeArchive.main.fetchUUIDList()
            onComplete?()
        }
    }
    
    func load(uuid:TimeStreamImageMapUUID, configuration:TimeStream.Configuration, onComplete:(()->())? = nil) {
        print("load composite [\(uuid.uuidString)]")
        if cache[uuid] == nil {
            Task {
                cache[uuid] = await TimeStreamImageMapArchive.main.fetch(uuid: uuid, configuration: configuration)
                onComplete?()
            }
        }
    }
    
    func save(imageMap: TimeStream.Composite.ImageMap, onComplete:(()->())? = nil) {
        print("save composite [\(imageMap.uuid.uuidString)]")
        cache[imageMap.uuid] = imageMap
        Task {
            await TimeStreamImageMapArchive.main.store(imageMap: imageMap)
            onComplete?()
        }
    }
    
    func remove(imageMap: TimeStream.Composite.ImageMap, onComplete:(()->())? = nil) {
        // TODO: Delete Function for Archive's Image Map Data File
//        print("remove composite [\(composite.uuid.uuidString)]")
//        Task {
//            await TimeStreamImageMapArchive.main.delete(uuid: imageMap.uuid)
//            onComplete?()
//        }
    }
}
