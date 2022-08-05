//
//  CosmicAlignmentSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/24/22.
//

import Foundation
import SpriteKit
import CoreMedia
import SwiftAA

class CosmicAlignmentSpriteNode: SKSpriteNode {
    
    static func create(size: CGSize) -> CosmicAlignmentSpriteNode {
        let sprite = CosmicAlignmentSpriteNode(texture: nil, color: .clear, size: size)
        sprite.setup()
        return sprite
    }
    
    func setup() {
        
        self.removeAllChildren()
        
        // Base12 30 degrees
        // Inner
        for i in 0...11 {
            let degree:Degree = Degree((Double(i)*30.0))+15
            let radius:CGFloat = size.height/5
            let zodiac = Arcana.Zodiac.from(degree: degree)
            let element = zodiac.element
            let modality = zodiac.modality
            
            
            
            let subSprite = getBase12Sprite(element, modality, glow: true)
            subSprite.size = CGSize(width: size.width/10, height: size.height/10)
            subSprite.position = CGPoint(x: 0, y: radius)
            
            let sprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            sprite.zRotation = CGFloat(degree.inRadians.value)
            
            sprite.addChild(subSprite)
            addChild(sprite)
        }
        
        // Base24 30 degrees
        // Inner
        for i in 0...35 {
            let degree:Degree = Degree((Double(i)*10.0))
            let radius:CGFloat = size.height/3
            let force = Arcana.Force.from(degree: degree)
            let zodiac = Arcana.Zodiac.from(degree: degree)
            let subZodiac = Arcana.Zodiac.subFrom(degree: degree)
            
            let subSprite = getBase36Sprite(force, zodiac.modality, subZodiac.modality, glow: true)
            subSprite.size = CGSize(width: size.width/10, height: size.height/10)
            subSprite.position = CGPoint(x: 0, y: radius)
            
            let sprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            sprite.zRotation = CGFloat(degree.inRadians.value)
            
            sprite.addChild(subSprite)
            addChild(sprite)
        }
        
        // Base24 30 degrees
        // Inner
        for i in 0...11 {
            let degree:Degree = Degree((Double(i)*30.0))-0.1
            let radius:CGFloat = size.height/4
            let force = Arcana.Force.from(degree: degree)
            let zodiac = Arcana.Zodiac.from(degree: degree)
            let subZodiac = Arcana.Zodiac.subFrom(degree: degree)
            
            let subSprite = getBase24CuspSprite(force, zodiac.modality, subZodiac.modality, glow: true)
            subSprite.size = CGSize(width: size.width/10, height: size.height/10)
            subSprite.position = CGPoint(x: 0, y: radius)
            
            let sprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            sprite.zRotation = CGFloat(degree.inRadians.value)
            
            sprite.addChild(subSprite)
            addChild(sprite)
        }
        
//
//        // Base24 15 degrees (cusps only)
//        // Outer
//        for i in 0...11 {
//            let degree = Degree((Double(i)*30.0))
//            let radius = size.width/6
//            let zodiac = Arcana.Zodiac.from(degree: degree)
//            let subZodiac = Arcana.Zodiac.subFrom(degree: degree)
//            let force = Arcana.Force.from(degree: degree)
//            let sprite = getBase24CuspSprite(force, zodiac.modality, subZodiac.modality, glow: true)
//            sprite.size = CGSize(width: size.width/8, height: size.height/8)
//            sprite.position = CGPoint(x: 0, y: radius)
//            sprite.anchorPoint = CGPoint(x: 0, y: -radius/sprite.size.height)
//            addChild(sprite)
//            sprite.zRotation = CGFloat(degree.value)
//        }
//
//        // Base36 10 degrees
//        // Mid
//        for i in 0...35 {
//            let degree = Degree((Double(i)*10))
//            let radius = size.width/4
//            let zodiac = Arcana.Zodiac.from(degree: degree)
//            let subZodiac = Arcana.Zodiac.subFrom(degree: degree)
//            let force = Arcana.Force.from(degree: degree)
//            let sprite = getBase36Sprite(force, zodiac.modality, subZodiac.modality, glow: true)
//            sprite.size = CGSize(width: size.width/9, height: size.height/9)
//            sprite.position = CGPoint(x: 0, y: radius)
//            sprite.anchorPoint = CGPoint(x: 0, y: -radius/sprite.size.height)
//            addChild(sprite)
//            sprite.zRotation = CGFloat(degree.value)
//        }
        
    }
    
    
    
    
    func getBase12Sprite(_ element: Arcana.Element, _ modality: Arcana.Modality, glow:Bool = true) -> SKSpriteNode {
        return SKSpriteNode(imageNamed: getBase12ImageName(element, modality))
    }
    
    // Base 12 [4E x 3M]
    func getBase12ImageName(_ element: Arcana.Element, _ modality: Arcana.Modality) -> String {
        switch element {
        case .air:
            switch modality {
            case .cardinal: return "base12-air-active-256x-glow.png"
            case .fixed: return "base12-air-static-256x-glow.png"
            case .mutable: return "base12-air-reactive-256x-glow.png"
            }
        case .water:
            switch modality {
            case .cardinal: return "base12-water-active-256x-glow.png"
            case .fixed: return "base12-water-static-256x-glow.png"
            case .mutable: return "base12-water-reactive-256x-glow.png"
            }
        case .earth:
            switch modality {
            case .cardinal: return "base12-earth-active-256x-glow.png"
            case .fixed: return "base12-earth-static-256x-glow.png"
            case .mutable: return "base12-earth-reactive-256x-glow.png"
            }
        case .fire:
            switch modality {
            case .cardinal: return "base12-fire-active-256x-glow.png"
            case .fixed: return "base12-fire-static-256x-glow.png"
            case .mutable: return "base12-fire-reactive-256x-glow.png"
            }
            
        }
    }
    
    
    func getBase24CuspSprite(_ force: Arcana.Force, _ topModality: Arcana.Modality, _ bottomModality: Arcana.Modality, glow:Bool = true) -> SKSpriteNode {
        return SKSpriteNode(imageNamed: getBase24CuspImageName(force, topModality, bottomModality))
    }
    // Base 24 cusps [4F x (3M + 3M)]
    func getBase24CuspImageName(_ force: Arcana.Force, _ topModality: Arcana.Modality, _ bottomModality: Arcana.Modality) -> String {
        switch force {
        case .light:
            if topModality == .cardinal && bottomModality == .mutable {
                return "base24-order-active-reactive-256x-glow.png"
            } else if topModality == .mutable && bottomModality == .fixed {
                return "base24-order-reactive-static-256x-glow.png"
            } else if topModality == .fixed && bottomModality == .cardinal {
                return "base24-order-static-active-256x-glow.png"
            }
        case .heat:
            if topModality == .cardinal && bottomModality == .mutable {
                return "base24-chaos-active-reactive-256x-glow.png"
            } else if topModality == .mutable && bottomModality == .fixed {
                return "base24-chaos-reactive-static-256x-glow.png"
            } else if topModality == .fixed && bottomModality == .cardinal {
                return "base24-chaos-static-active-256x-glow.png"
            }
        case .magnetism:
            if topModality == .cardinal && bottomModality == .fixed {
                return "base24-void-active-static-256x-glow.png"
            } else if topModality == .mutable && bottomModality == .cardinal {
                return "base24-void-reactive-active-256x-glow.png"
            } else if topModality == .fixed && bottomModality == .mutable {
                return "base24-void-static-reactive-256x-glow.png"
            }
        case .gravity:
            if topModality == .cardinal && bottomModality == .fixed {
                return "base24-void-active-static-256x-glow.png"
            } else if topModality == .mutable && bottomModality == .cardinal {
                return "base24-void-reactive-active-256x-glow.png"
            } else if topModality == .fixed && bottomModality == .mutable {
                return "base24-void-static-reactive-256x-glow.png"
            }
        }
        return ""
    }
    
    
    func getBase36Sprite(_ force: Arcana.Force, _ modality: Arcana.Modality, _ subModality: Arcana.Modality, glow:Bool = true) -> SKSpriteNode {
        return SKSpriteNode(imageNamed: getBase36ImageName(force, modality, subModality))
    }
    // Base 36 [4F x 3M x 3M]
    func getBase36ImageName(_ force: Arcana.Force, _ modality: Arcana.Modality, _ subModality: Arcana.Modality) -> String {
        switch force {
        case .light:
            switch modality {
            case .cardinal:
                switch subModality {
                case .cardinal: return "base36-order-active-active-256x-glow.png"
                case .fixed: return "base36-order-active-static-256x-glow.png"
                case .mutable: return "base36-order-active-reactive-256x-glow.png"
                }
            case .fixed:
                switch subModality {
                case .cardinal: return "base36-order-static-active-256x-glow.png"
                case .fixed: return "base36-order-static-static-256x-glow.png"
                case .mutable: return "base36-order-static-reactive-256x-glow.png"
                }
            case .mutable:
                switch subModality {
                case .cardinal: return "base36-order-reactive-active-256x-glow.png"
                case .fixed: return "base36-order-reactive-static-256x-glow.png"
                case .mutable: return "base36-order-reactive-reactive-256x-glow.png"
                }
            }
        case .heat:
            switch modality {
            case .cardinal:
                switch subModality {
                case .cardinal: return "base36-chaos-active-active-256x-glow.png"
                case .fixed: return "base36-chaos-active-static-256x-glow.png"
                case .mutable: return "base36-chaos-active-reactive-256x-glow.png"
                }
            case .fixed:
                switch subModality {
                case .cardinal: return "base36-chaos-static-active-256x-glow.png"
                case .fixed: return "base36-chaos-static-static-256x-glow.png"
                case .mutable: return "base36-chaos-static-reactive-256x-glow.png"
                }
            case .mutable:
                switch subModality {
                case .cardinal: return "base36-chaos-reactive-active-256x-glow.png"
                case .fixed: return "base36-chaos-reactive-static-256x-glow.png"
                case .mutable: return "base36-chaos-reactive-reactive-256x-glow.png"
                }
            }
        case .magnetism:
            switch modality {
            case .cardinal:
                switch subModality {
                case .cardinal: return "base36-core-active-active-256x-glow.png"
                case .fixed: return "base36-core-active-static-256x-glow.png"
                case .mutable: return "base36-core-active-reactive-256x-glow.png"
                }
            case .fixed:
                switch subModality {
                case .cardinal: return "base36-core-static-active-256x-glow.png"
                case .fixed: return "base36-core-static-static-256x-glow.png"
                case .mutable: return "base36-core-static-reactive-256x-glow.png"
                }
            case .mutable:
                switch subModality {
                case .cardinal: return "base36-core-reactive-active-256x-glow.png"
                case .fixed: return "base36-core-reactive-static-256x-glow.png"
                case .mutable: return "base36-core-reactive-reactive-256x-glow.png"
                }
            }
        case .gravity:
            switch modality {
            case .cardinal:
                switch subModality {
                case .cardinal: return "base36-void-active-active-256x-glow.png"
                case .fixed: return "base36-void-active-static-256x-glow.png"
                case .mutable: return "base36-void-active-reactive-256x-glow.png"
                }
            case .fixed:
                switch subModality {
                case .cardinal: return "base36-void-static-active-256x-glow.png"
                case .fixed: return "base36-void-static-static-256x-glow.png"
                case .mutable: return "base36-void-static-reactive-256x-glow.png"
                }
            case .mutable:
                switch subModality {
                case .cardinal: return "base36-void-reactive-active-256x-glow.png"
                case .fixed: return "base36-void-reactive-static-256x-glow.png"
                case .mutable: return "base36-void-reactive-reactive-256x-glow.png"
                }
            }
        }
    }
    
    
    
}
