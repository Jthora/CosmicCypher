//
//  TimeStreamMaterial.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/9/21.
//

import SceneKit

extension TimeStream {
    class Material {
        static func create(_ type:TimeStreamMaterialType) -> SCNMaterial {
            switch type {
            case .test:
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "testTexture")
                return material
            case .psionicStrip(starcharts: let starcharts):
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "testTexture")
                return material
            }
        }
    }
}
