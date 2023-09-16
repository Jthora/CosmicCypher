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
    func update(starChart:StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType], selectedAspects:[CoreAstrology.AspectRelationType]) {
        updateZodiac(starChart: starChart, selectedPlanets: selectedPlanets)
        updateCusps(starChart: starChart, selectedPlanets: selectedPlanets)
        updateDecans(starChart: starChart, selectedPlanets: selectedPlanets)
    }
    
    // Base 12 Zodiac
    func updateZodiac(starChart:StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType]) {
        // set the alpha of each Zodiac Sprite
        // Stack Arkana levels by taking the sub and main of each node for Zodiac
        
        let alignments = starChart.alignments
        let zodiacIndex = starChart.produceZodiacIndex(limitList: selectedPlanets)
        
        var alphaLevels: [Arcana.Zodiac: CGFloat] = [:]
        
        // Setup Alpha Levels Buffer for Sprites
        for zodiac in Arcana.Zodiac.allCases {
            alphaLevels[zodiac] = 0
            let grossAlpha = zodiacIndex.distribution(for: zodiac) + zodiacIndex.subDistribution(for: zodiac)
            alphaLevels[zodiac] = min(1, grossAlpha)
        }
        
        for (zodiac, alpha) in alphaLevels {
            self.spritesBase12[zodiac]?.alpha = alpha
        }
    }
    
    // Base 24(12) Cusps
    func updateCusps(starChart:StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType]) {
        // Set the alpha of each Cusp Sprite
        // Stack Arkana levels by taking the sub and main of each node for Cusp
        
        let alignments = starChart.alignments
        let cuspIndex = starChart.produceCuspIndex(limitList: selectedPlanets)//produceZodiacIndex(limitList: selectedPlanets)
        var alphaLevels: [Arcana.Cusp: CGFloat] = [:]
        
        // Setup Alpha Levels Buffer for Sprites
        for cusp in Arcana.Cusp.allCases {
            alphaLevels[cusp] = 0
            let grossAlpha = cuspIndex.distribution(for: cusp) + cuspIndex.subDistribution(for: cusp)
            alphaLevels[cusp] = min(1, grossAlpha)
        }
        
        for (cusp, alpha) in alphaLevels {
            self.spritesBase24[cusp]?.alpha = alpha
        }
    }
    
    // Base 36 Decans
    func updateDecans(starChart:StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType]) {
        // Set the alpha of each Decan Sprite
        // Stack Arkana levels by taking the sub and main of each node for Decan
        
        let alignments = starChart.alignments
        let decanIndex = starChart.produceDecanIndex(limitList: selectedPlanets)//produceZodiacIndex(limitList: selectedPlanets)
        var alphaLevels: [Arcana.Decan: CGFloat] = [:]
        
        // Setup Alpha Levels Buffer for Sprites
        for decan in Arcana.Decan.allCases {
            alphaLevels[decan] = 0
            let grossAlpha = decanIndex.distribution(for: decan) + decanIndex.subDistribution(for: decan)
            alphaLevels[decan] = min(1, grossAlpha)
        }
        
        for (decan, alpha) in alphaLevels {
            self.spritesBase36[decan]?.alpha = alpha
        }
    }
}
