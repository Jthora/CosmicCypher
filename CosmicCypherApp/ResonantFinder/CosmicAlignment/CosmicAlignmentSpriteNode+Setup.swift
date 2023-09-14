//
//  CosmicAlignmentSpriteNode+Setup.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SwiftAA
import SpriteKit


extension CosmicAlignmentSpriteNode {
    func setup() {
        self.removeAllChildren()
        
        setupBase12()
        setupBase24()
        setupBase36()
    }
}

extension CosmicAlignmentSpriteNode {
    func setupBase12() {
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
    }
    
    func setupBase24() {
        // Base24 (15 degrees)
        // Mid
        for i in 0...11 {
            // Get Cusp Sprite Type
            var degree:Degree = Degree((Double(i)*30.0))-0.1
            let radius:CGFloat = size.height/3.8
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
    }
    
    func setupBase36() {
        // Base 36 (10 degrees)
        // Outer
        for i in 0...35 {
            var degree:Degree = Degree((Double(i)*10.0))+5
            let radius:CGFloat = size.height/2.8
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
}
