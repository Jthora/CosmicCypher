//
//  SpriteNodeCosmicEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 12/3/20.
//

import SpriteKit
import SwiftAA

class SpriteNodeCosmicEvent: SKSpriteNode {
    
    var spriteLeftPlanet:SKSpriteNode
    var spriteLeftTop:SKSpriteNode
    var spriteLeftBottom:SKSpriteNode
    
    var spriteCentralTopFraction:SKLabelNode
    var spriteCentralAspect:SKSpriteNode
    var spriteCentralBottomDistance:SKLabelNode
    
    var spriteRightPlanet:SKSpriteNode
    var spriteRightTop:SKSpriteNode
    var spriteRightBottom:SKSpriteNode
    
    
    init?(aspect:CoreAstrology.Aspect, primaryBodyLongitude:Degree, secondaryBodyLongitude:Degree, size:CGSize) {
        
        let leftPlanetImageName = aspect.primaryBody.type.imageName
        let rightPlanetImageName = aspect.secondaryBody.type.imageName
        let centralAspectImageName = aspect.relation.type.imageName
        let fraction = aspect.relation.type.fraction
        
        // Bottom Distance
        var degrees = aspect.relation.degrees.value.truncatingRemainder(dividingBy: 360)
        if degrees > 180 {
            degrees = 180-(degrees-180)
        }
        let distance = String(degrees - (aspect.relation.type.degree.value ?? 0))
        spriteCentralBottomDistance = SKLabelNode(text: distance)
        
        // Top Fraction
        spriteCentralTopFraction = SKLabelNode(text: fraction)
        
        // Central Aspect
        spriteCentralAspect = SKSpriteNode(imageNamed: centralAspectImageName)
        
        // Planets
        spriteLeftPlanet = SKSpriteNode(imageNamed: leftPlanetImageName ?? "")
        spriteRightPlanet = SKSpriteNode(imageNamed: rightPlanetImageName ?? "")
        
        // Left Zodiac
        let leftPrimaryZodiac = Arcana.Zodiac.from(degree: primaryBodyLongitude)
        let leftSecondaryZodiac = Arcana.Zodiac.subFrom(degree: primaryBodyLongitude)
        if leftPrimaryZodiac.duality == .yang {
            spriteLeftTop = SKSpriteNode(imageNamed: leftPrimaryZodiac.imageNameWhite)
            spriteLeftBottom = SKSpriteNode(imageNamed: leftSecondaryZodiac.imageNameWhite)
        } else {
            spriteLeftTop = SKSpriteNode(imageNamed: leftSecondaryZodiac.imageNameWhite)
            spriteLeftBottom = SKSpriteNode(imageNamed: leftPrimaryZodiac.imageNameWhite)
        }
        
        // Right Zodiac
        let rightPrimaryZodiac = Arcana.Zodiac.from(degree: secondaryBodyLongitude)
        let rightSecondaryZodiac = Arcana.Zodiac.subFrom(degree: secondaryBodyLongitude)
        if leftPrimaryZodiac.duality == .yang {
            spriteRightTop = SKSpriteNode(imageNamed: rightPrimaryZodiac.imageNameWhite)
            spriteRightBottom = SKSpriteNode(imageNamed: rightSecondaryZodiac.imageNameWhite)
        } else {
            spriteRightTop = SKSpriteNode(imageNamed: rightSecondaryZodiac.imageNameWhite)
            spriteRightBottom = SKSpriteNode(imageNamed: rightPrimaryZodiac.imageNameWhite)
        }
        
        super.init(texture: nil, color: .clear, size: size)
        
        // 1/3 Size
        let thirdSize = CGSize(width: size.width/3, height: size.height/3)
        
        spriteCentralAspect.size = thirdSize
        spriteLeftPlanet.size = thirdSize
        spriteRightPlanet.size = thirdSize
        spriteLeftTop.size = thirdSize
        spriteLeftBottom.size = thirdSize
        spriteRightTop.size = thirdSize
        spriteRightBottom.size = thirdSize
        
        spriteLeftPlanet.position = CGPoint(x: -thirdSize.width/1.5, y: 0)
        spriteRightPlanet.position = CGPoint(x: thirdSize.width/1.5, y: 0)
        spriteLeftTop.position = CGPoint(x: -thirdSize.width/1.5, y: thirdSize.height/2)
        spriteLeftBottom.position = CGPoint(x: -thirdSize.width/1.5, y: -thirdSize.height/2)
        spriteRightTop.position = CGPoint(x: thirdSize.width/1.5, y: thirdSize.height/2)
        spriteRightBottom.position = CGPoint(x: thirdSize.width/1.5, y: -thirdSize.height/2)
        
        self.addChild(spriteCentralAspect)
        self.addChild(spriteLeftPlanet)
        self.addChild(spriteRightPlanet)
        self.addChild(spriteLeftTop)
        self.addChild(spriteLeftBottom)
        self.addChild(spriteRightTop)
        self.addChild(spriteRightBottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
