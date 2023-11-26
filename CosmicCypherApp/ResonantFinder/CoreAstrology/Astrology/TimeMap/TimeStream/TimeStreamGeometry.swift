//
//  TimeStreamGeometry.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 8/8/21.
//

import SceneKit

extension TimeStream {
    class Geometry {
        static func create(_ type:TimeStreamGeometryType) -> SCNGeometry {
            switch type {
            case .rectangle(let position, let width, let height):
                return SCNGeometry.rectangle(position: position, width: width, height: height)
            }
        }
    }
}
