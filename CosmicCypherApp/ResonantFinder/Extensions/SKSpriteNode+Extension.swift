//
//  SKSpriteNode+Extension.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/13/22.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    enum CenterOption {
        case scene(_ scene:SKScene)
        case size(_ size:CGSize)
    }
    
    func center(_ centerOption:CenterOption? = nil) {
        
        guard let centerOption = centerOption else {
            guard let scene = scene else { return }
            self.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
            return
        }
        
        switch centerOption {
        case .scene(let scene):
            self.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        case .size(let size):
            self.position = CGPoint(x: size.width/2, y: size.height/2)
        }
    }
}

extension SKSpriteNode {

    func aspectFillToSize(fillSize: CGSize) {

        if texture != nil {
            self.size = texture!.size()

            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width

            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio

            self.setScale(scaleRatio)
        }
    }

}
