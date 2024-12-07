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
                guard let image = UIImage(named: "testTexture") else {
                    print("Failed to load image: testTexture")
                    return material
                }
                material.diffuse.contents = image
                return material
            case .psionicStrip(starcharts: let starcharts):
                let material = SCNMaterial()
                guard let image = UIImage(named: "testTexture") else {
                    print("Failed to load image: testTexture")
                    return material
                }
                material.diffuse.contents = image
                return material
            }
        }
    }
}
