//
//  ResonanceReportViewController+CosmicDisk.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/16/23.
//

import UIKit
import SpriteKit


extension ResonanceReportViewController {
    // MARK: Central Cosmic Disk
    
    func updateCosmicDisk() {
        let starChart = StarChart.Core.current
        let selectedPlanets = StarChart.Core.selectedPlanets
        let selectedAspects = StarChart.Core.selectedAspects
        self.cosmicDiskSprite.update(starChart: starChart, selectedPlanets: selectedPlanets, selectedAspects: selectedAspects)
    }
}
