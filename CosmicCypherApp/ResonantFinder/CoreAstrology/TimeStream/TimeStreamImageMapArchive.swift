//
//  TimeStreamImageMapArchive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/21/22.
//

import Foundation
import SwiftAA
import CoreData

// MARK: TimeStream Composite Hash
public typealias TimeStreamImageMapUUID = TimeStreamCompositeUUID

extension TimeStreamImageMapArchive {
    public typealias UUIDList = [TimeStreamImageMapUUID]
}

// MARK: TimeStream ImageMap Archive
public final actor TimeStreamImageMapArchive {
    
    static let imageMapFileLocation:String = "ImageMaps/"
    static let imageMapFileURL: URL = { return URL(string: "\(imageMapFileLocation)")! }()
    
    // MARK: Singleton
    static let main: TimeStreamImageMapArchive = TimeStreamImageMapArchive()
    private init() {}
        
    // MARK: Store an Image Map to File Folder
    func store(imageMap: TimeStream.Composite.ImageMap) {
        for imageStripSet in imageMap.imageStripSets {
            for (nodeType, imageStrip) in imageStripSet {
                let success = saveImageStrip(uiImage: imageStrip.uiImage, uuid: imageMap.uuid, nodeType: nodeType)
                if !success {
                    print("Error:: could not save imageStrip: \(imageStripFileName(uuid: imageMap.uuid, nodeType: nodeType))")
                    continue
                }
            }
        }
    }
    
    // MARK: Fetch All TimeStream Image Map from Archive
    func fetchAll() async throws -> TimeStreamImageMapCache {
        var imageMaps = TimeStreamImageMapCache()
        let uuidList = try await TimeStreamCompositeRegistry.main.uuidList
        for uuid in uuidList {
            
            guard let configuration = TimeStreamCompositeRegistry.main.cache[uuid]?.configuration,
                  let imageMap = try await self.fetch(uuid: uuid, configuration: configuration) else {
                throw NSError(domain: "TimeStream Composite not found for hash: \(uuid)", code: -1, userInfo: nil)
            }
            imageMaps[uuid] = imageMap
        }
        return imageMaps
    }
    
    
    
    
    // MARK: Fetch an Image Map from File Folder
    func fetch(uuid: TimeStreamCompositeUUID, configuration:TimeStream.Configuration) -> TimeStream.Composite.ImageMap? {
        var imageStripSets: [TimeStreamImageStripSet] = []
        for timestream in configuration.timeStreams {
            var imageStripSet = TimeStreamImageStripSet()
            for nodeType in configuration.nodeTypes {
                guard let uiImage = getSavedImageStrip(uuid: uuid, nodeType: nodeType) else { continue }
                let imageStrip = TimeStream.ImageStrip(uiImage: uiImage,
                                                       nodeType: nodeType,
                                                       colorRenderMode: timestream.colorRenderMode)
                imageStripSet[nodeType] = imageStrip
            }
            imageStripSets.append(imageStripSet)
        }
        return TimeStream.Composite.ImageMap(uuid: uuid, imageStripSets: imageStripSets)
    }
    
    func saveImageStrip(uiImage: UIImage, uuid: TimeStreamCompositeUUID, nodeType: CoreAstrology.AspectBody.NodeType) -> Bool {
        guard let data = uiImage.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            let filename:String = imageStripFileName(uuid: uuid, nodeType: nodeType)
            try data.write(to: directory.appendingPathComponent(filename)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImageStrip(uuid: TimeStreamCompositeUUID, nodeType: CoreAstrology.AspectBody.NodeType) -> UIImage? {
        let filename:String = imageStripFileName(uuid: uuid, nodeType: nodeType)
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(filename).path)
        }
        return nil
    }
    
    func imageStripFileName(uuid: TimeStreamCompositeUUID, nodeType: CoreAstrology.AspectBody.NodeType) -> String {
        return "ImageStrips/\(uuid.uuidString)/\(nodeType.fileNameSuffix).png"
    }
}
