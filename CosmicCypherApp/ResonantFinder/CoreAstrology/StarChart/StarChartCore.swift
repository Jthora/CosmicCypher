//
//  StarChartCore.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/9/22.
//

import SpriteKit
import SwiftAA



let DEFAULT_SELECTED_ASPECTS:[CoreAstrology.AspectRelationType] = [.conjunction,
                                                                   .opposition,
                                                                   .sextile,
                                                                   .trine,
                                                                   .square]
let DEFAULT_SELECTED_NODETYPES:[CoreAstrology.AspectBody.NodeType] = [.ascendant,
                                                                    .midheaven,
                                                                    .lunarAscendingNode,
                                                                    .lunarPerigee,
                                                                    .moon,
                                                                    .sun,
                                                                    .mercury,
                                                                    .venus,
                                                                    .mars,
                                                                    .jupiter,
                                                                    .saturn,
                                                                    .uranus,
                                                                    .neptune]

extension StarChart {
    class Core {
        
        // Stored Values
        static func savePreferredCoordinates(starChart:StarChart) {
            UserDefaults.standard.set(starChart.coordinates.longitude.value, forKey: _preferredCoordinatesLongitudeKey)
            UserDefaults.standard.set(starChart.coordinates.latitude.value, forKey: _preferredCoordinatesLatitudeKey)
            UserDefaults.standard.set(starChart.coordinates.altitude.value, forKey: _preferredCoordinatesAltitudeKey)
        }
        
        static func loadPreferredCoordinates() -> GeographicCoordinates {
            let long = UserDefaults.standard.double(forKey: _preferredCoordinatesLongitudeKey)
            let lat = UserDefaults.standard.double(forKey: _preferredCoordinatesLatitudeKey)
            let alt = UserDefaults.standard.double(forKey: _preferredCoordinatesAltitudeKey)
            return GeographicCoordinates(positivelyWestwardLongitude: Degree(long), latitude: Degree(lat), altitude: Meter(alt))
        }
        
        // Action/Reaction Delegates
        static private var _reactors:[StarChartCoreReactive] = []
        static func add(reactive:StarChartCoreReactive) { _reactors.append(reactive) }
        static func remove(reactive:StarChartCoreReactive) { _reactors.removeAll(where: { $0 === reactive } ) }
        static func react(to action:StarChart.Core.Action) { for reactor in _reactors { reactor.starChartCore(didAction: action) } }
        
        private static let _selectedNodeTypesKey:String = "_selectedNodeTypesKey"
        private static let _selectedAspectsKey:String = "_selectedAspectsKey"
        
        private static let _preferredCoordinatesLongitudeKey:String = "_preferredCoordinatesLongitudeKey"
        private static let _preferredCoordinatesLatitudeKey:String = "_preferredCoordinatesLatitudeKey"
        private static let _preferredCoordinatesAltitudeKey:String = "_preferredCoordinatesAltitudeKey"
        
        static private var _current: StarChart = StarChart(date: Date(), coordinates: loadPreferredCoordinates())
        static var current: StarChart {
            set {
                _current = newValue
                savePreferredCoordinates(starChart: newValue)
//                DispatchQueue.main.async {
//                    print("current starchart changed \(newValue.date.formatted(date: .numeric, time: .shortened))")
//                }
            }
            get {
                return _current
            }
        }
        static var currentCosmicAlignment: CosmicAlignment {
            return current.cosmicAlignment(selectedNodeTypes: selectedNodeTypes)
        }
        static var sortedAspects: [CoreAstrology.Aspect] {
            return current.sortedAspects(selectedNodeTypes: selectedNodeTypes,
                                         selectedAspects: selectedAspects)
        }
        
        static var selectedPlanets: [CoreAstrology.AspectBody.NodeType] {
            return selectedNodeTypes.filter { $0.hasGravity }
        }
        
        static var selectedNodeTypes: [CoreAstrology.AspectBody.NodeType] = fetchSelectedNodeTypes() {
            didSet {
                let rawValues = selectedNodeTypes.map { $0.rawValue }
                let dataArray = NSArray(array: rawValues, copyItems: false)
                guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: false) else {
                    print("selectedPlanets cannot encode data")
                    return
                }
                print("encoded selectedNodeTypes data")
                UserDefaults.standard.set(encodedData, forKey: _selectedNodeTypesKey)
            }
        }
        
        static var selectedAspects: [CoreAstrology.AspectRelationType] = fetchSelectedAspects() {
            didSet {
                storeAspects()
            }
        }
        private static func storeAspects() {
            let rawValues = selectedAspects.map { $0.rawValue }
            let dataArray = NSArray(array: rawValues, copyItems: false)
            guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: false) else {
                print("selectedAspects cannot encode data")
                return
            }
            print("encoded selectedAspects data")
            UserDefaults.standard.set(encodedData, forKey: _selectedAspectsKey)
        }
        
        private static func fetchSelectedNodeTypes() -> [CoreAstrology.AspectBody.NodeType] {
            guard let decoded  = UserDefaults.standard.object(forKey: _selectedNodeTypesKey) as? Data else {
                print("cannot decode data: defaulting to DEFAULT_SELECTED_NODETYPES")
                defer { storeAspects() }
                return DEFAULT_SELECTED_NODETYPES
            }
            guard let rawValues = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: decoded) else {
                print("cannot unarchivedObject data: defaulting to DEFAULT_SELECTED_NODETYPES")
                defer { storeAspects() }
                return DEFAULT_SELECTED_NODETYPES
            }
            print("decoded data: \(rawValues)")
            let values = rawValues.toIntArray()
            let selectedPlanets = values.map({ CoreAstrology.AspectBody.NodeType(rawValue: $0)! })
            return selectedPlanets
        }
        
        private static func fetchSelectedAspects() -> [CoreAstrology.AspectRelationType] {
            guard let decoded  = UserDefaults.standard.object(forKey: _selectedAspectsKey) as? Data else {
                print("cannot decode data: defaulting to DEFAULT_SELECTED_ASPECTS")
                return DEFAULT_SELECTED_ASPECTS
            }
            guard let rawValues = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: decoded) else {
                print("cannot unarchivedObject data: defaulting to DEFAULT_SELECTED_ASPECTS")
                return DEFAULT_SELECTED_ASPECTS
            }
            print("decoded data: \(rawValues)")
            let values = rawValues.toIntArray()
            let selectedAspects = values.map({ CoreAstrology.AspectRelationType(rawValue: $0)! })
            return selectedAspects
        }
        
        // MARK: StarChart Playback
        // StarChart RealTime Playback Controller
        static var playbackController = {
            var controller = StarChartRealTimePlaybackController()
            controller.date = StarChart.Core.current.date
            controller.mode = .pause
            return controller
        }()
        
        // MARK: Render StarChart
        static var isRendering:Bool = true
        static var cancelComposite:Bool = false
        static func renderStarChart(starChart:StarChart? = nil, size:CGSize) {
            // BYPASS ⚠️
            react(to: .renderStop)
            return
            print("react to .renderStart")
            react(to: .renderStart)
            
            StarChart.Composite.render(starChart: starChart ?? current,
                                       size: size,
                                       nodeTypes: selectedNodeTypes,
                                       onProgress: { progressPercentage in
                                        //print("react to .renderProgress")
                                        react(to: .renderProgress(completion: progressPercentage))
                                    }, onComplete: { compositeImage in
                                        let compositeTexture = SKTexture(cgImage: compositeImage)
                                        let sprite = StarChartSpriteNode(texture: compositeTexture, color: .clear, size: size)
                                        sprite.position = size.midPoint
                                        //print("react to .renderComplete")
                                        react(to: .renderComplete(sprite: sprite))
                                    }, onStop: {
                                        //print("react to .renderStop")
                                        react(to: .renderStop)
                                    })
            
        }
        
        static func cancelRender() {
            StarChart.Composite.Renderer.cancel()
        }
        
        
        static func createStarChartSpriteNode(size:CGSize, date:Date? = nil, coordinates:GeographicCoordinates? = nil, nodeTypes: [CoreAstrology.AspectBody.NodeType], onComplete:((_ sprite: StarChartSpriteNode)->Void)? = nil, onProgress:((_ percentageCompleted:Float)->Void)? = nil, onStop:(()->Void)? = nil) {
            
            let starChart:StarChart
            
            if let date:Date = date,
               let coordinates = coordinates {
                starChart = StarChart(date: date, coordinates: coordinates)
            } else {
                starChart = current
            }
            
            var planetNodes = Array(starChart.planetNodes.values)
            planetNodes.removeAll { (planetNode) -> Bool in
                return !StarChart.Core.selectedNodeTypes.contains(planetNode.nodeType)
            }
            
            StarChart.Composite.render(starChart: starChart,
                                       size: size,
                                       nodeTypes: nodeTypes,
                                       onProgress: onProgress,
                                       onComplete: { compositeImage in
                                                        let powereredRingZonesTexture = SKTexture(cgImage: compositeImage)
                                                        let sprite = StarChartSpriteNode(texture: powereredRingZonesTexture, color: .clear, size: size)
                                                        sprite.position = size.midPoint
                                                        onComplete?(sprite)
                                                    },
                                       onStop: onStop)
            
        }
        
        
        static var selectedPlanetNodeStates: [PlanetNodeState] {
            var planetNodeStates: [PlanetNodeState] = []
            for nodeType in selectedPlanets {
                do {
                    let planetNodeState = try PlanetNodeStateRegistry.main.getPlanetNodeState(starChart: current, nodeType: nodeType)
                    planetNodeStates.append(planetNodeState)
                } catch let error {
                    print("ERROR: \(error)")
                    continue
                }
            }
            return planetNodeStates
        }
        
        // MARK: Max - Exa/Deb/Rise/Fall
        static var maxExaltation:Double {
            var maxExaltation: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxExaltation = max(maxExaltation,planetNodeState.exaltation)
            }
            return maxExaltation
        }
        
        static var maxDebilitation:Double {
            var maxDebilitation: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxDebilitation = max(maxDebilitation,planetNodeState.debilitation)
            }
            return maxDebilitation
        }
        
        static var maxRise:Double {
            var maxRise: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxRise = max(maxRise,planetNodeState.rise)
            }
            return maxRise
        }
        
        static var maxFall:Double {
            var maxFall: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxFall = max(maxFall,planetNodeState.fall)
            }
            return maxFall
        }
        
        // MARK: Average - Exa/Deb/Rise/Fall
        static var averageExaltation:Double {
            var maxExaltation: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxExaltation += planetNodeState.exaltation
            }
            return maxExaltation/Double(selectedPlanetNodeStates.count)
        }
        
        static var averageDebilitation:Double {
            var maxDebilitation: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxDebilitation += planetNodeState.debilitation
            }
            return maxDebilitation/Double(selectedPlanetNodeStates.count)
        }
        
        static var averageRise:Double {
            var averageRise: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                averageRise += planetNodeState.rise
            }
            return averageRise/Double(selectedPlanetNodeStates.count)
        }
        
        static var averageFall:Double {
            var averageFall: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                averageFall += planetNodeState.fall
            }
            return averageFall/Double(selectedPlanetNodeStates.count)
        }
        
        // MARK: Min - Exa/Deb/Rise/Fall
        static var minExaltation:Double {
            var maxExaltation: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxExaltation = max(maxExaltation,planetNodeState.exaltation)
            }
            return maxExaltation
        }
        
        static var minDebilitation:Double {
            var maxDebilitation: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxDebilitation = max(maxDebilitation,planetNodeState.debilitation)
            }
            return maxDebilitation
        }
        
        static var minRise:Double {
            var maxRise: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxRise = max(maxRise,planetNodeState.rise)
            }
            return maxRise
        }
        
        static var minFall:Double {
            var maxFall: Double = 0
            for planetNodeState in selectedPlanetNodeStates {
                maxFall = max(maxFall,planetNodeState.fall)
            }
            return maxFall
        }
    }
    
    
}

extension StarChart.Core {
    
    class SelectedAspects:NSObject, Codable {
        var selectedAspects:[Int]
    }
    
    class SelectedNodeTypes:NSObject, Codable {
        var selectedNodeTypes:[Int]
    }
}


extension NSArray {
    func toIntArray() -> [Int] {
        var intArray = [Int]()
        
        for element in self {
            if let intValue = element as? Int {
                intArray.append(intValue)
            }
        }
        
        return intArray
    }
}
