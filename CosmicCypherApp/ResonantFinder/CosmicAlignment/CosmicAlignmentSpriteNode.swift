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
        
        // Base12 (30 degrees)
        // Inner
        for i in 0...11 {
            // Get Zodiac Sprite Type
            var degree:Degree = Degree((Double(i)*30.0))+15
            let radius:CGFloat = size.height/5
            let zodiac = Arcana.Zodiac.from(degree: degree)
            let element = zodiac.element
            let modality = zodiac.modality
            
            // Setup Zodiac Sprite and Container Sprite
            let zodiacSprite = getBase12Sprite(element, modality, glow: true)
            zodiacSprite.size = CGSize(width: size.width/10, height: size.height/10)
            zodiacSprite.position = CGPoint(x: 0, y: radius)
            let containerSprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            
            // Rotate Sprite
            degree += 180
            degree = Degree(degree.value.truncatingRemainder(dividingBy: 360))
            degree = 360 - degree
            containerSprite.zRotation = CGFloat(degree.inRadians.value)
            
            // Add Sprite
            containerSprite.addChild(zodiacSprite)
            addChild(containerSprite)
        }
        
        // Base24 (15 degrees)
        // Mid
        for i in 0...11 {
            // Get Cusp Sprite Type
            var degree:Degree = Degree((Double(i)*30.0))-0.1
            let radius:CGFloat = size.height/4
            let force = Arcana.Force.from(degree: degree)
            let zodiac = Arcana.Zodiac.from(degree: degree)
            let subZodiac = Arcana.Zodiac.subFrom(degree: degree)
            let topZodiac = zodiac.duality == .yang ? zodiac : subZodiac
            let bottomZodiac = subZodiac.duality == .yang ? zodiac : subZodiac
            
            // Setup Cusp Sprite and Container Sprite
            let cuspSprite = getBase24CuspSprite(force, topZodiac.modality, bottomZodiac.modality, glow: true)
            cuspSprite.size = CGSize(width: size.width/10, height: size.height/10)
            cuspSprite.position = CGPoint(x: 0, y: radius)
            let containerSprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            
            // Rotate Sprite
            degree += 180
            degree = Degree(degree.value.truncatingRemainder(dividingBy: 360))
            degree = 360 - degree
            containerSprite.zRotation = CGFloat(degree.inRadians.value)
            
            // Add Sprite
            containerSprite.addChild(cuspSprite)
            addChild(containerSprite)
        }
        
        // Base 36 (10 degrees)
        // Outer
        for i in 0...35 {
            var degree:Degree = Degree((Double(i)*10.0))+5
            let radius:CGFloat = size.height/3
            let element = Arcana.Element.from(degree: degree)
            let force = Arcana.Force.from(degree: degree)
            let zodiac = Arcana.Zodiac.from(degree: degree)
            let isPrime = Arcana.Element.isPrime(degree: degree)
            print("sprite @(\(degree)) element[\(element)] force[\(force)] zodiac[\(zodiac)]")
            
            let decanSprite = getBase36Sprite(element, isPrime ? nil : force, zodiac.modality, glow: true)
            decanSprite.size = CGSize(width: size.width/10, height: size.height/10)
            decanSprite.position = CGPoint(x: 0, y: radius)
            let containerSprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            
            // Rotate Sprite
            degree += 180
            degree = Degree(degree.value.truncatingRemainder(dividingBy: 360))
            degree = 360 - degree
            containerSprite.zRotation = CGFloat(degree.inRadians.value)
            
            // Add Sprite
            containerSprite.addChild(decanSprite)
            addChild(containerSprite)
        }
    }
    
    // MARK: Sprite Images
    // Base 12 Zodiac Sprites
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
    
    // Base 24 Cusp Sprites
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
                return "base24-core-active-static-256x-glow.png"
            } else if topModality == .mutable && bottomModality == .cardinal {
                return "base24-core-reactive-active-256x-glow.png"
            } else if topModality == .fixed && bottomModality == .mutable {
                return "base24-core-static-reactive-256x-glow.png"
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
    
    // Base 36 Decan Sprites
    func getBase36Sprite(_ element: Arcana.Element, _ force: Arcana.Force?, _ modality: Arcana.Modality, glow:Bool = true) -> SKSpriteNode {
        return SKSpriteNode(imageNamed: getBase36ImageName(element, force, modality))
    }
    // Base 36 [4E x 2F1P x 3M]
    func getBase36ImageName(_ element: Arcana.Element, _ force: Arcana.Force?, _ modality: Arcana.Modality) -> String {
        
        switch element {
        case .fire:
            switch force {
            case .heat:
                switch modality {
                case .cardinal: return "base36-fire-active-chaos-256x-glow.png" // "base36-air-active-order-256x-glow.png"
                case .fixed: return "base36-fire-static-chaos-256x-glow.png"
                case .mutable: return "base36-fire-reactive-chaos-256x-glow.png"
                }
            case .magnetism:
                switch modality {
                case .cardinal: return "base36-fire-active-core-256x-glow.png"
                case .fixed: return "base36-fire-static-core-256x-glow.png"
                case .mutable: return "base36-fire-reactive-core-256x-glow.png"
                }
            default:
                switch modality {
                case .cardinal: return "base36-fire-active-prime-256x-glow.png"
                case .fixed: return "base36-fire-static-prime-256x-glow.png"
                case .mutable: return "base36-fire-reactive-prime-256x-glow.png"
                }
            }
        case .earth:
            switch force {
            case .magnetism:
                switch modality {
                case .cardinal: return "base36-earth-active-core-256x-glow.png"
                case .fixed: return "base36-earth-static-core-256x-glow.png"
                case .mutable: return "base36-earth-reactive-core-256x-glow.png"
                }
            case .light:
                switch modality {
                case .cardinal: return "base36-earth-active-order-256x-glow.png"
                case .fixed: return "base36-earth-static-order-256x-glow.png"
                case .mutable: return "base36-earth-reactive-order-256x-glow.png"
                }
            default:
                switch modality {
                case .cardinal: return "base36-earth-active-prime-256x-glow.png"
                case .fixed: return "base36-earth-static-prime-256x-glow.png"
                case .mutable: return "base36-earth-reactive-prime-256x-glow.png"
                }
            }
        case .air:
            switch force {
            case .light:
                switch modality {
                case .cardinal: return "base36-air-active-order-256x-glow.png" // base36-air-active-order-256x-glow.png
                case .fixed: return "base36-air-static-order-256x-glow.png"
                case .mutable: return "base36-air-reactive-order-256x-glow.png"
                }
            case .gravity:
                switch modality {
                case .cardinal: return "base36-air-active-void-256x-glow.png"
                case .fixed: return "base36-air-static-void-256x-glow.png"
                case .mutable: return "base36-air-reactive-void-256x-glow.png"
                }
            default:
                switch modality {
                case .cardinal: return "base36-air-active-prime-256x-glow.png"
                case .fixed: return "base36-air-static-prime-256x-glow.png"
                case .mutable: return "base36-air-reactive-prime-256x-glow.png"
                }
            }
        case .water:
            switch force {
            case .gravity:
                switch modality {
                case .cardinal: return "base36-water-active-void-256x-glow.png"
                case .fixed: return "base36-water-static-void-256x-glow.png"
                case .mutable: return "base36-water-reactive-void-256x-glow.png"
                }
            case .heat:
                switch modality {
                case .cardinal: return "base36-water-active-chaos-256x-glow.png"
                case .fixed: return "base36-water-static-chaos-256x-glow.png"
                case .mutable: return "base36-water-reactive-chaos-256x-glow.png"
                }
            default:
                switch modality {
                case .cardinal: return "base36-water-active-prime-256x-glow.png"
                case .fixed: return "base36-water-static-prime-256x-glow.png"
                case .mutable: return "base36-water-reactive-prime-256x-glow.png"
                }
            }
        }
    }
    
    
    
}
