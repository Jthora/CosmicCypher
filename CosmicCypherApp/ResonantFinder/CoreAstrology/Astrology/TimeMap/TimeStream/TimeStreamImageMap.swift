//
//  TimeStreamImageMap.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/3/22.
//

import Foundation

extension TimeStream.Composite {
    public class ImageMap {
        
        let uuid:UUID
        let imageStripSets:[TimeStreamImageStripSet]
        
        public static func create(uuid:UUID, configuration:TimeStream.Configuration, onComplete:((ImageMap)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            print("❇️ New Image Map")
            var imageStripSets = [TimeStreamImageStripSet]()
            for timeStream in configuration.timeStreams {
                timeStream.loadStarCharts(sampleCount: configuration.sampleCount, onComplete: { starCharts in
                    print("Timestream Composite ImageMap loaded [\(configuration.sampleCount)] starcharts for ImageMap")
                    let imageStripSet = timeStream.generateImageStrips(nodeTypes: configuration.nodeTypes)
                    let imageMap = ImageMap(uuid: uuid, imageStripSets: imageStripSets)
                    onComplete?(imageMap)
                }) { completion, starchart in
                    onProgress?(completion)
                }
            }
        }
        
        init(uuid:UUID, imageStripSets:[TimeStreamImageStripSet]) {
            self.imageStripSets = imageStripSets
            self.uuid = uuid
        }
    }
}

