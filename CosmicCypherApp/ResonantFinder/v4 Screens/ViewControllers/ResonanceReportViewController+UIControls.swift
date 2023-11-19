//
//  ResonanceReportViewController+UIControls.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 8/5/22.
//

import UIKit

extension ResonanceReportViewController {
    
    // MARK: UI Controls
    func toggleCentralUI(animate:Bool = true) {
        DispatchQueue.main.async {
            self.hideCentralUI = !self.hideCentralUI
            if animate {
                if self.hideCentralUI {
                    UIView.animate(withDuration: 0.5) {
                        self.dateTimeCoordsLabel.alpha = 0
                        self.aspectEventScannerButton.alpha = 0
                        self.instructionsButton.alpha = 0
                        self.planetSelectButton.alpha = 0
                        self.settingsButton.alpha = 0
                        self.shareButton.alpha = 0
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.dateTimeCoordsLabel.alpha = 1
                        self.aspectEventScannerButton.alpha = 1
                        self.instructionsButton.alpha = 1
                        self.planetSelectButton.alpha = 1
                        self.settingsButton.alpha = 1
                        self.shareButton.alpha = 1
                    }
                }
            } else {
                if self.hideCentralUI {
                    self.dateTimeCoordsLabel.alpha = 0
                    self.aspectEventScannerButton.alpha = 0
                    self.instructionsButton.alpha = 0
                    self.planetSelectButton.alpha = 0
                    self.settingsButton.alpha = 0
                    self.shareButton.alpha = 0
                } else {
                    self.dateTimeCoordsLabel.alpha = 1
                    self.aspectEventScannerButton.alpha = 1
                    self.instructionsButton.alpha = 1
                    self.planetSelectButton.alpha = 1
                    self.settingsButton.alpha = 1
                    self.shareButton.alpha = 1
                }
            }
        }
    }
    
    // MARK: Display/Hide Bar Labels
    /// set display settings for text visibility of energy levels based on orientation of device screen and size available
    func animateBarLabels() {
        if resonanceBarsView.bounds.width < resonanceBarsView.bounds.height {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.resonanceBarAirLabel.alpha = 0
                self.resonanceBarFireLabel.alpha = 0
                self.resonanceBarWaterLabel.alpha = 0
                self.resonanceBarEarthLabel.alpha = 0
                self.resonanceBarSpiritLabel.alpha = 0
                self.resonanceBarLightLabel.alpha = 0
                self.resonanceBarShadowLabel.alpha = 0
                self.resonanceBarSoulLabel.alpha = 0
                self.resonanceBarCoreLabel.alpha = 0
                self.resonanceBarAlphaLabel.alpha = 0
                self.resonanceBarOrderLabel.alpha = 0
                self.resonanceBarMonoLabel.alpha = 0
                self.resonanceBarVoidLabel.alpha = 0
                self.resonanceBarOmegaLabel.alpha = 0
                self.resonanceBarChaosLabel.alpha = 0
                self.resonanceBarPolyLabel.alpha = 0
            } completion: { _ in
                self.resonanceBarAirLabel.isHidden = true
                self.resonanceBarFireLabel.isHidden = true
                self.resonanceBarWaterLabel.isHidden = true
                self.resonanceBarEarthLabel.isHidden = true
                self.resonanceBarSpiritLabel.isHidden = true
                self.resonanceBarLightLabel.isHidden = true
                self.resonanceBarShadowLabel.isHidden = true
                self.resonanceBarSoulLabel.isHidden = true
                self.resonanceBarCoreLabel.isHidden = true
                self.resonanceBarAlphaLabel.isHidden = true
                self.resonanceBarOrderLabel.isHidden = true
                self.resonanceBarMonoLabel.isHidden = true
                self.resonanceBarVoidLabel.isHidden = true
                self.resonanceBarOmegaLabel.isHidden = true
                self.resonanceBarChaosLabel.isHidden = true
                self.resonanceBarPolyLabel.isHidden = true
            }
        } else {
            self.resonanceBarAirLabel.isHidden = false
            self.resonanceBarFireLabel.isHidden = false
            self.resonanceBarWaterLabel.isHidden = false
            self.resonanceBarEarthLabel.isHidden = false
            self.resonanceBarSpiritLabel.isHidden = false
            self.resonanceBarLightLabel.isHidden = false
            self.resonanceBarShadowLabel.isHidden = false
            self.resonanceBarSoulLabel.isHidden = false
            self.resonanceBarCoreLabel.isHidden = false
            self.resonanceBarAlphaLabel.isHidden = false
            self.resonanceBarOrderLabel.isHidden = false
            self.resonanceBarMonoLabel.isHidden = false
            self.resonanceBarVoidLabel.isHidden = false
            self.resonanceBarOmegaLabel.isHidden = false
            self.resonanceBarChaosLabel.isHidden = false
            self.resonanceBarPolyLabel.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.resonanceBarAirLabel.alpha = 1
                self.resonanceBarFireLabel.alpha = 1
                self.resonanceBarWaterLabel.alpha = 1
                self.resonanceBarEarthLabel.alpha = 1
                self.resonanceBarSpiritLabel.alpha = 1
                self.resonanceBarLightLabel.alpha = 1
                self.resonanceBarShadowLabel.alpha = 1
                self.resonanceBarSoulLabel.alpha = 1
                self.resonanceBarCoreLabel.alpha = 1
                self.resonanceBarAlphaLabel.alpha = 1
                self.resonanceBarOrderLabel.alpha = 1
                self.resonanceBarMonoLabel.alpha = 1
                self.resonanceBarVoidLabel.alpha = 1
                self.resonanceBarOmegaLabel.alpha = 1
                self.resonanceBarChaosLabel.alpha = 1
                self.resonanceBarPolyLabel.alpha = 1
            } completion: { _ in
            }
        }
    }
    
    func resetEnergyLevels() {
//        self.barAir.setProgress(0)
//        self.barFire.setProgress(0)
//        self.barWater.setProgress(0)
//        self.barEarth.setProgress(0)
//
//        self.barSpirit.setProgress(0)
//        self.barLight.setProgress(0)
//        self.barShadow.setProgress(0)
//        self.barSoul.setProgress(0)
//
//        self.barCore.setProgress(0)
//        self.barAlpha.setProgress(0)
//        self.barOrder.setProgress(0)
//        self.barVoid.setProgress(0)
//        self.barOmega.setProgress(0)
//        self.barChaos.setProgress(0)
//
//        self.barOne.setProgress(0)
//        self.barMany.setProgress(0)
//
//        self.barCorePotential.setProgress(0)
//        self.barAlphaPotential.setProgress(0)
//        self.barOrderPotential.setProgress(0)
//        self.barVoidPotential.setProgress(0)
//        self.barOmegaPotential.setProgress(0)
//        self.barChaosPotential.setProgress(0)
//
//        self.barSpiritPotential.setProgress(0)
//        self.barLightPotential.setProgress(0)
//        self.barShadowPotential.setProgress(0)
//        self.barSoulPotential.setProgress(0)
        
    }
    
    // MARK: Update Energy Levels
    // Update Energy Levels
    func updateEnergyLevels(starChart:StarChart) {
        
        guard !StarChart.Core.selectedPlanets.isEmpty else {return}
        
        let cosmicAlignment = StarChart.Core.currentCosmicAlignment
        
        DispatchQueue.main.async {
            self.barAir?.setProgress(Float(cosmicAlignment.level(.air, .baseline)))
            self.barFire?.setProgress(Float(cosmicAlignment.level(.fire, .baseline)))
            self.barWater?.setProgress(Float(cosmicAlignment.level(.water, .baseline)))
            self.barEarth?.setProgress(Float(cosmicAlignment.level(.earth, .baseline)))

            self.barSpirit?.setProgress(Float(cosmicAlignment.level(.spirit, .baseline)))
            self.barLight?.setProgress(Float(cosmicAlignment.level(.light, .baseline)))
            self.barShadow?.setProgress(Float(cosmicAlignment.level(.shadow, .baseline)))
            self.barSoul?.setProgress(Float(cosmicAlignment.level(.soul, .baseline)))

            self.barCore?.setProgress(Float(cosmicAlignment.level(.core, .baseline)))
            self.barAlpha?.setProgress(Float(cosmicAlignment.level(.alpha, .baseline)))
            self.barOrder?.setProgress(Float(cosmicAlignment.level(.order, .baseline)))
            self.barVoid?.setProgress(Float(cosmicAlignment.level(.void, .baseline)))
            self.barOmega?.setProgress(Float(cosmicAlignment.level(.omega, .baseline)))
            self.barChaos?.setProgress(Float(cosmicAlignment.level(.chaos, .baseline)))

            self.barOne?.setProgress(Float(cosmicAlignment.level(.mono, .baseline)))
            self.barMany?.setProgress(Float(cosmicAlignment.level(.poly, .baseline)))

            self.barSpiritPotential?.setProgress(Float(cosmicAlignment.level(.spirit, .potential)))
            self.barLightPotential?.setProgress(Float(cosmicAlignment.level(.light, .potential)))
            self.barShadowPotential?.setProgress(Float(cosmicAlignment.level(.shadow, .potential)))
            self.barSoulPotential?.setProgress(Float(cosmicAlignment.level(.soul, .potential)))

            self.barCorePotential?.setProgress(Float(cosmicAlignment.level(.core, .potential)))
            self.barAlphaPotential?.setProgress(Float(cosmicAlignment.level(.alpha, .potential)))
            self.barOrderPotential?.setProgress(Float(cosmicAlignment.level(.order, .potential)))
            self.barVoidPotential?.setProgress(Float(cosmicAlignment.level(.void, .potential)))
            self.barOmegaPotential?.setProgress(Float(cosmicAlignment.level(.omega, .potential)))
            self.barChaosPotential?.setProgress(Float(cosmicAlignment.level(.chaos, .potential)))
        }
    }
    
    // MARK: Update Modality Meters
    // Update Modality Meters
    func updateModalityMeters(starChart:StarChart) {
        let zodiacIndex = starChart.produceZodiacIndex(limitList: StarChart.Core.selectedNodeTypes)
        
        modalityIndicatorAries.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .aries, normalized: false)))
        modalityIndicatorTaurus.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .taurus, normalized: false)))
        modalityIndicatorGemini.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .gemini, normalized: false)))
        modalityIndicatorCancer.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .cancer, normalized: false)))
        modalityIndicatorLeo.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .leo, normalized: false)))
        modalityIndicatorVirgo.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .virgo, normalized: false)))
        modalityIndicatorLibra.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .libra, normalized: false)))
        modalityIndicatorScorpio.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .scorpio, normalized: false)))
        modalityIndicatorSagittarius.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .sagittarius, normalized: false)))
        modalityIndicatorCapricorn.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .capricorn, normalized: false)))
        modalityIndicatorAquarius.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .aquarius, normalized: false)))
        modalityIndicatorPisces.alpha = CGFloat(min(1,zodiacIndex.totalDistribution(for: .pisces, normalized: false)))
        
        let cardinalEnergy = String(format: "%0.1f", zodiacIndex.cardinalEnergy.rounded(toIncrement: 0.001)*100)
        let fixedEnergy = String(format: "%0.1f", zodiacIndex.fixedEnergy.rounded(toIncrement: 0.001)*100)
        let mutableEnergy = String(format: "%0.1f", zodiacIndex.mutableEnergy.rounded(toIncrement: 0.001)*100)
        
        cardinalNumberLabel.text = "\(cardinalEnergy)%"
        fixedNumberLabel.text = "\(fixedEnergy)%"
        mutableNumberLabel.text = "\(mutableEnergy)%"
    }
    
    
    // TODO: Update TimeStream Visualizer
    func updateTimeStreamVisualizer() {
        
    }
    
    
}
