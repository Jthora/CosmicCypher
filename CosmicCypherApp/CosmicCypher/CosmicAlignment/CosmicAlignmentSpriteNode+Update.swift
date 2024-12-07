//
//  CosmicAlignmentSpriteNode+Update.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SwiftAA
import SpriteKit

extension CosmicAlignmentSpriteNode {
    
    // Update
    func update(starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], selectedAspects:[CoreAstrology.AspectRelationType]) {
        DispatchQueue.main.async {
            self.updateZodiac(starChart: starChart, selectedNodeTypes: selectedNodeTypes)
            self.updateCusps(starChart: starChart, selectedNodeTypes: selectedNodeTypes)
            self.updateDecans(starChart: starChart, selectedNodeTypes: selectedNodeTypes)
            self.updatePlanetaryPositions(starChart: starChart, selectedNodeTypes: selectedNodeTypes)
            self.updateAspectLines(starChart: starChart, selectedNodeTypes: selectedNodeTypes, selectedAspects: selectedAspects)
        }
    }
    
    func blackout() {
        // Set all Zodiac Sprites to alpha 0
        for zodiac in Arcana.Zodiac.allCases {
            if let sprite = self.spritesBase12[zodiac] {
                sprite.alpha = 0
            }
        }

        // Set all Cusp Sprites to alpha 0
        for cusp in Arcana.Cusp.allCases {
            if let sprite = self.spritesBase24[cusp] {
                sprite.alpha = 0
            }
        }

        // Set all Decan Sprites to alpha 0
        for decan in Arcana.Decan.allCases {
            if let sprite = self.spritesBase36[decan] {
                sprite.alpha = 0
            }
        }

        // Set planetary positions to alpha 0
        self.planetaryPlacementSpriteNode.alpha = 0

        // Set aspect lines to alpha 0
        self.aspectLinesSpriteNode.alpha = 0

        // Additional cleanup: ensure no animations are running
        self.removeAllActions()
    }
    
    // Reset
    func reset() {
        // Hide all Zodiac Sprites
        for zodiac in Arcana.Zodiac.allCases {
            if let sprite = self.spritesBase12[zodiac] {
                sprite.alpha = 1 // Hide by setting alpha to 0
            }
        }

        // Hide all Cusp Sprites
        for cusp in Arcana.Cusp.allCases {
            if let sprite = self.spritesBase24[cusp] {
                sprite.alpha = 1 // Hide by setting alpha to 0
            }
        }

        // Hide all Decan Sprites
        for decan in Arcana.Decan.allCases {
            if let sprite = self.spritesBase36[decan] {
                sprite.alpha = 1 // Hide by setting alpha to 0
            }
        }

        // Hide all planetary positions
        self.planetaryPlacementSpriteNode.alpha = 0

        // Hide all aspect lines
        self.aspectLinesSpriteNode.alpha = 0

        // Additional cleanup: ensure no animations are running
        self.removeAllActions()
    }
    
    // Base 12 Zodiac
    func updateZodiac(starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], animate:Bool = true) {
        // set the alpha of each Zodiac Sprite
        // Stack Arkana levels by taking the sub and main of each node for Zodiac
        
        let zodiacIndex = starChart.produceZodiacIndex(limitList: selectedNodeTypes)
        var alphaLevels: [Arcana.Zodiac: CGFloat] = [:]
        
        // Setup Alpha Levels Buffer for Sprites
        for zodiac in Arcana.Zodiac.allCases {
            alphaLevels[zodiac] = 0
            let grossAlpha = zodiacIndex.distribution(for: zodiac) + zodiacIndex.subDistribution(for: zodiac)
            alphaLevels[zodiac] = min(1, grossAlpha)
        }
        
        // Change Alpha (with animation)
        if animate {
            // Animate the alpha changes
            for (zodiac, targetAlpha) in alphaLevels {
                if let sprite = self.spritesBase12[zodiac] {
                    let currentAlpha = sprite.alpha
                    let fadeDuration = 0.5 // Set the duration of the fade animation as desired

                    // Create an SKAction to fade from the current alpha to the target alpha
                    let fadeAction = SKAction.fadeAlpha(to: targetAlpha, duration: fadeDuration)

                    // Run the fade action on the sprite
                    sprite.run(fadeAction)
                }
            }
        } else {
            for (zodiac, targetAlpha) in alphaLevels {
                self.spritesBase12[zodiac]?.alpha = targetAlpha
            }
        }
        
        // Animate planetary positions back to alpha 1
        let planetaryFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
        self.planetaryPlacementSpriteNode.run(planetaryFadeIn)

        // Animate aspect lines back to alpha 1
        let aspectLinesFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
        self.aspectLinesSpriteNode.run(aspectLinesFadeIn)
    }
    
    // Base 24(12) Cusps
    func updateCusps(starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], animate:Bool = true) {
        // Set the alpha of each Cusp Sprite
        // Stack Arkana levels by taking the sub and main of each node for Cusp
        
        let cuspIndex = starChart.produceCuspIndex(limitList: selectedNodeTypes)//produceZodiacIndex(limitList: selectedPlanets)
        var alphaLevels: [Arcana.Cusp: CGFloat] = [:]
        
        // Setup Alpha Levels Buffer for Sprites
        for cusp in Arcana.Cusp.allCases {
            alphaLevels[cusp] = 0
            let grossAlpha = cuspIndex.distribution(for: cusp) + cuspIndex.subDistribution(for: cusp)
            alphaLevels[cusp] = min(1, grossAlpha)
        }
        
        // Change Alpha (with animation)
        if animate {
            // Animate the alpha changes
            for (cusp, targetAlpha) in alphaLevels {
                if let sprite = self.spritesBase24[cusp] {
                    let currentAlpha = sprite.alpha
                    let fadeDuration = 0.5 // Set the duration of the fade animation as desired

                    // Create an SKAction to fade from the current alpha to the target alpha
                    let fadeAction = SKAction.fadeAlpha(to: targetAlpha, duration: fadeDuration)

                    // Run the fade action on the sprite
                    sprite.run(fadeAction)
                }
            }
        } else {
            for (cusp, targetAlpha) in alphaLevels {
                self.spritesBase24[cusp]?.alpha = targetAlpha
            }
        }
    }
    
    // Base 36 Decans
    func updateDecans(starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], animate:Bool = true) {
        // Set the alpha of each Decan Sprite
        // Stack Arkana levels by taking the sub and main of each node for Decan
        
        let decanIndex = starChart.produceDecanIndex(limitList: selectedNodeTypes)//produceZodiacIndex(limitList: selectedPlanets)
        var alphaLevels: [Arcana.Decan: CGFloat] = [:]
        
        // Setup Alpha Levels Buffer for Sprites
        for decan in Arcana.Decan.allCases {
            alphaLevels[decan] = 0
            let distribution = decanIndex.distribution(for: decan)
            let subDistribution = decanIndex.subDistribution(for: decan)
            let grossAlpha = distribution + subDistribution
            if grossAlpha > 0 {
                alphaLevels[decan] = min(1, grossAlpha)
            }
        }
        
        // Change Alpha (with animation)
        if animate {
            // Animate the alpha changes
            for (decan, targetAlpha) in alphaLevels {
                if let sprite = self.spritesBase36[decan] {
                    let currentAlpha = sprite.alpha
                    let fadeDuration = 0.5 // Set the duration of the fade animation as desired

                    // Create an SKAction to fade from the current alpha to the target alpha
                    let fadeAction = SKAction.fadeAlpha(to: targetAlpha, duration: fadeDuration)

                    // Run the fade action on the sprite
                    sprite.run(fadeAction)
                }
            }
        } else {
            for (decan, targetAlpha) in alphaLevels {
                self.spritesBase36[decan]?.alpha = targetAlpha
            }
        }
    }
    
    func updatePlanetaryPositions(starChart: StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]) {
        self.planetaryPlacementSpriteNode.update(with: starChart, selectedNodeTypes: selectedNodeTypes)
    }
    
    func updateAspectLines(starChart: StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], selectedAspects:[CoreAstrology.AspectRelationType]) {
        self.aspectLinesSpriteNode.update(with: starChart, selectedNodeTypes: selectedNodeTypes, selectedAspects: selectedAspects)
    }
}
