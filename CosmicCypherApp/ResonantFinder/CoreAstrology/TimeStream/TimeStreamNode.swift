//
//  TimeStreamNode.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/8/21.
//

import SceneKit

extension TimeStream {
    class Node {
        @MainActor static func create(_ type:TimeStreamNodeType, position:SCNVector3, width:Float, height:Float) -> SCNNode {
            switch type {
            case .test:
                let geometry = TimeStream.Geometry.create(.rectangle(position: position,width: width,height: height))
                let material = TimeStream.Material.create(.test)
                geometry.materials = [material]
                let node = SCNNode(geometry: geometry)
                
                return node
            case .planetaryStrip:
                let node = SCNNode(geometry: TimeStream.Geometry.create(.rectangle(position: position,width: width,height: height)))
                
                return node
            case .astrologicalMarking:
                let node = SCNNode(geometry: TimeStream.Geometry.create(.rectangle(position: position,width: width,height: height)))
                
                return node
            }
        }
    }
}

