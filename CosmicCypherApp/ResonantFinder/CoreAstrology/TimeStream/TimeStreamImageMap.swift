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
        
        init(uuid:UUID, imageStripSets:[TimeStreamImageStripSet]) {
            self.imageStripSets = imageStripSets
            self.uuid = uuid
        }
        
        init(uuid:UUID, configuration:TimeStream.Configuration, onComplete:((ImageMap)->Void)? = nil, onProgress:((_ completion:Double)->Void)? = nil) {
            self.uuid = uuid
            var imageStripSets = [TimeStreamImageStripSet]()
            
            for timeStream in configuration.timeStreams {
                timeStream.loadStarCharts(sampleCount: configuration.sampleCount, onComplete: {
                    print("timestream loaded")
                }, onProgress: onProgress)
                imageStripSets.append(timeStream.generateImageStrips(nodeTypes: configuration.nodeTypes))
            }
            self.imageStripSets = imageStripSets
            onComplete?(self)
        }
    }
}
