//
//  TimeStreamCore.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/5/22.
//

import UIKit

extension TimeStream {
    public final class Core: ObservableObject {
        
        // MARK: Initial Activation
        private static let _secretInitCompleteKey:String = "_secretInitCompleteKey"
        static func initialActivation() {
            if UserDefaults.standard.bool(forKey: _secretInitCompleteKey) == true {
                reloadComposites()
            } else {
                saveAllDefaultComposites()
                UserDefaults.standard.set(true, forKey: _secretInitCompleteKey)
            }
        }
        
        // MARK: Composite Count
        private static let _compositeCountKey:String = "_lastCompositeCountKey"
        private static let _hasSavedCompositeCountKey:String = "_hasSavedCompositeCountKey"
        
        static func saveCompositeCount(count:Int) {
            UserDefaults.standard.set(count, forKey: _compositeCountKey)
        }
        
        static func loadCompositeCount() -> Int {
            return UserDefaults.standard.integer(forKey: _compositeCountKey)
        }
        
        private static var _compositeCount:Int = {
            if UserDefaults.standard.bool(forKey: _hasSavedCompositeCountKey) == true {
                return loadCompositeCount()
            } else {
                saveCompositeCount(count: TimeStream.Generator.Option.defaultSet.count)
                UserDefaults.standard.set(true, forKey: _hasSavedCompositeCountKey)
                return TimeStream.Generator.Option.defaultSet.count
            }
        }()
        static var compositeCount:Int {
            return _compositeCount
        }
        
        // MARK: Composite UUIDs
        private static let _compositeUUIDsKey:String = "_lastCompositeUUIDsKey"
        private static let _hasSavedCompositeUUIDsKey:String = "_hasSavedCompositeUUIDsKey"
        
        static func saveCompositeUUID(uuid: UUID) {
            guard let uuids = _compositeUUIDs,
                  uuids.contains(uuid) != true else {
                print("ERROR: saveCompositeUUID uuid already added")
                return
            }
            _compositeUUIDs!.append(uuid)
            saveCompositeUUIDs(uuids: _compositeUUIDs!)
        }
        static func saveCompositeUUIDs(uuids:[UUID]) {
            let rawData = try? uuids.rawData()
            UserDefaults.standard.set(rawData, forKey: _compositeUUIDsKey)
            UserDefaults.standard.set(true, forKey: _hasSavedCompositeUUIDsKey)
        }
        
        static func compositeUUID(for indexPath:IndexPath) -> UUID? {
            let uuids = loadCompositeUUIDs()
            guard indexPath.row < uuids.count else {return nil}
            return uuids[indexPath.row]
        }
        static private var _compositeUUIDs: [UUID]? = nil
        static func loadCompositeUUIDs() -> [UUID] {
            if let uuids = _compositeUUIDs {
                return uuids
            }
            if let rawData = UserDefaults.standard.object(forKey: _compositeUUIDsKey) as? Data,
                let uuids = TimeStreamCompositeArchive.UUIDList.from(rawData) {
                _compositeUUIDs = uuids
                return uuids
            } else {
                let uuids = TimeStream.Generator.Option.defaultSet.map({ _ in return UUID() })
                _compositeUUIDs = uuids
                saveCompositeUUIDs(uuids: uuids)
                return uuids
            }
        }
        
        // MARK: Action/Reaction Delegates
        static private var _reactors:[TimeStreamCoreReactive] = []
        static func add(reactive:TimeStreamCoreReactive) { _reactors.append(reactive) }
        static func remove(reactive:TimeStreamCoreReactive) { _reactors.removeAll(where: { $0 === reactive } ) }
        static func react(to action:TimeStream.Core.Action) { for reactor in _reactors { reactor.timeStreamCore(didAction: action) } }
        
        // MARK: Current TimeStream
        static private var _current: TimeStream = TimeStream.create(.astroHarmonics3DayForecast)
        static var current: TimeStream {
            set {
                _current = newValue
            }
            get {
                return _current
            }
        }
        
        // MARK: Registry and Archive
        static var registry:TimeStreamRegistry { return TimeStreamRegistry.main }
        static var archive:TimeStreamArchive { return TimeStreamArchive.main }
        
        static var compositeRegistry:TimeStreamCompositeRegistry { return TimeStreamCompositeRegistry.main }
        static var compositeArchive:TimeStreamCompositeArchive { return TimeStreamCompositeArchive.main }
        
        
        static func composite(for indexPath: IndexPath) -> Composite? {
            guard currentComposites.count > indexPath.row else {return nil}
            return currentComposites[indexPath.row]
        }
        
        static var currentComposites: [Composite] {
            return compositeRegistry.cache.values.filter { return compositeRegistry.uuidList.contains($0.uuid) }
        }
        
        static var currentlyEditingComposite: Composite? = nil
        
        
        public static func saveAllDefaultComposites() {
            Task {
                let defaultComposites = generateDefaultComposites()
                for composite in defaultComposites {
                    compositeRegistry.save(composite: composite)
                }
                reloadComposites()
                print("Saving All Defaults - \(compositeRegistry.cache.values.count) Composites to Save")
            }
        }
        
        static func generateDefaultComposites() -> [TimeStream.Composite] {
            return TimeStream.generateDefaultComposites()
        }
        
        static func addNewComposite(uuid:UUID, preset: TimeStream.Preset) { addNewComposite(uuid: uuid, option: preset.timestreamGeneratorOption) }
        static func addNewComposite(uuid: UUID = UUID(), option: TimeStream.Generator.Option) {
            
            guard uuidList.contains(uuid) == false else { return }
            _compositeCount = TimeStreamCompositeRegistry.main.uuidList.count+1
            
            /// Setup
            let name = option.title
            let timestream  = option.generate()
            let nodeTypes = option.nodeTypes
            let sampleCount = option.sampleCount
            let configuration = TimeStream.Configuration(sampleCount: sampleCount, primaryChart: nil, secondaryChart: nil, timeStreams: [timestream], nodeTypes: nodeTypes)
            
            
            /// React Start
            DispatchQueue.main.async {
                TimeStream.Core.react(to: .onLoadTimeStream(loadTimeStreamAction: .start(uuid: uuid, name: name, configuration: configuration)))
            }
            
            /// Create Composite
            let composite = TimeStream.Composite(name: name, uuid: uuid, configuration: configuration, onComplete: { _ in
                print("timestream composite loaded")
            } , onProgress: { completion in
                /// React Progress
                DispatchQueue.main.async {
                    TimeStream.Core.react(to: .onLoadTimeStream(loadTimeStreamAction: .progress(uuid: uuid, completion: completion)))
                }
            })
            
            /// Add Composite to List
            //composites.append(composite)
            TimeStreamCompositeRegistry.main.save(composite: composite)
            _compositeCount = TimeStreamCompositeRegistry.main.uuidList.count
            saveCompositeCount(count: _compositeCount)
            
            /// React Complete
            DispatchQueue.main.async {
                // Complete Loader Animation and Show TimeStream in Cell
                TimeStream.Core.react(to: .onLoadTimeStream(loadTimeStreamAction: .complete(uuid: uuid, composite: composite)))
            }
        }
        
        static func reloadComposites() {
            Task {
                TimeStreamCompositeRegistry.main.reload {
                    print("Preload Complete! - \(compositeRegistry.cache.values.count) Composites Loaded")
                    react(to: .update(updateAction: .composites(composites: compositeRegistry.cache)))
                }
            }
        }
        
        static var starCharts: [StarChartHashKey: StarChart] {
            return StarChartRegistry.main.cache
        }
//
//        static var timeStreams: [TimeStreamHash: TimeStream] {
//            return TimeStreamRegistry.main.cache
//        }
        
        static var uuidList: [TimeStreamCompositeUUID] {
            return TimeStreamCompositeRegistry.main.uuidList
        }
        
        static var composites: [TimeStreamCompositeUUID: TimeStream.Composite] {
            return TimeStreamCompositeRegistry.main.cache
        }
        
        static var planetStates: [PlanetStateHash: PlanetState] {
            return PlanetStateRegistry.main.cache
        }
        
//        static var planetStateTimelines: [PlanetStateTimelineHash: PlanetStateTimeline] {
//            return PlanetStateRegistry.main.timelineCache
//        }
        
        
        
        
    }
}


extension TimeStream.Core {
    
    
    static func duplicateTimeStreamComposite() {
        print("Duplicate TimeStream Composite")
        // TODO: functionality for Duplicate TimeStream Composite
        
    }
    
    static func delete(timeStreamComposite composite:TimeStream.Composite) {
        print("Delete TimeStream Composite")
        // TODO: functionality for Delete TimeStream Composite
        TimeStreamCompositeRegistry.main.cache[composite.uuid] = nil
        TimeStreamCompositeRegistry.main.uuidList.removeAll(where: { $0 == composite.uuid } )
        _compositeCount = TimeStreamCompositeRegistry.main.uuidList.count
        saveCompositeCount(count: _compositeCount)
        Task {
            await TimeStreamCompositeArchive.main.delete(uuid: composite.uuid)
        }
    }
    
}
