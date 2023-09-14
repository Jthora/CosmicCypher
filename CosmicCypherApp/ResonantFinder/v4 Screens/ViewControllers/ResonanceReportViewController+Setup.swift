//
//  ResonanceReportViewController+Setup.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 8/5/22.
//

import UIKit
import SpriteKit


extension ResonanceReportViewController {
    
    
    // MARK: Setup
    // Setup
    func setup() {
        //setupTimeStreamVisualizer()
        setupBars()
        setupSpriteKitScene()
        //setupRenderAnimation()
        resetEnergyLevels()
        update()
        renderStarChart()
        setupCosmicAlignmentSprite()
        setupPlanetPlacementSprite()
        setupAspectLinesSprite()
    }
    
    func setupBars() {
        
        barAir = LevelBarView(frame: barAirView.frame, sideAlignment: .right)
        barAirView.addSubview(barAir!)
        barAir!.centerInSuperview()
        barAir!.width(to: barAirView)
        barAir!.height(to: barAirView)
        barAir!.setBarColor(uiColor: UIColor.from(.air))
        
        barFire = LevelBarView(frame: barFireView.frame, sideAlignment: .right)
        barFireView.addSubview(barFire!)
        barFire!.centerInSuperview()
        barFire!.width(to: barFireView)
        barFire!.height(to: barFireView)
        barFire!.setBarColor(uiColor: UIColor.from(.fire))
        
        barWater = LevelBarView(frame: barWaterView.frame, sideAlignment: .right)
        barWaterView.addSubview(barWater!)
        barWater!.centerInSuperview()
        barWater!.width(to: barWaterView)
        barWater!.height(to: barWaterView)
        barWater!.setBarColor(uiColor: UIColor.from(.water))
        
        barEarth = LevelBarView(frame: barEarthView.frame, sideAlignment: .right)
        barEarthView.addSubview(barEarth!)
        barEarth!.centerInSuperview()
        barEarth!.width(to: barEarthView)
        barEarth!.height(to: barEarthView)
        barEarth!.setBarColor(uiColor: UIColor.from(.earth))
        
        barSpirit = LevelBarView(frame: barSpiritView.frame, sideAlignment: .left)
        barSpiritView.addSubview(barSpirit!)
        barSpirit!.centerInSuperview()
        barSpirit!.width(to: barSpiritView)
        barSpirit!.height(to: barSpiritView)
        barSpirit!.setBarColor(uiColor: UIColor.from(.spirit))
        
        barLight = LevelBarView(frame: barLightView.frame, sideAlignment: .left)
        barLightView.addSubview(barLight!)
        barLight!.centerInSuperview()
        barLight!.width(to: barLightView)
        barLight!.height(to: barLightView)
        barLight!.setBarColor(uiColor: UIColor.from(.light))
        
        barShadow = LevelBarView(frame: barShadowView.frame, sideAlignment: .left)
        barShadowView.addSubview(barShadow!)
        barShadow!.centerInSuperview()
        barShadow!.width(to: barShadowView)
        barShadow!.height(to: barShadowView)
        barShadow!.setBarColor(uiColor: UIColor.from(.shadow))
        
        barSoul = LevelBarView(frame: barSoulView.frame, sideAlignment: .left)
        barSoulView.addSubview(barSoul!)
        barSoul!.centerInSuperview()
        barSoul!.width(to: barSoulView)
        barSoul!.height(to: barSoulView)
        barSoul!.setBarColor(uiColor: UIColor.from(.soul))
        
        barCore = LevelBarView(frame: barCoreView.frame, sideAlignment: .right)
        barCoreView.addSubview(barCore!)
        barCore!.centerInSuperview()
        barCore!.width(to: barCoreView)
        barCore!.height(to: barCoreView)
        barCore!.setBarColor(uiColor: UIColor.from(.core))
        
        barVoid = LevelBarView(frame: barVoidView.frame, sideAlignment: .left)
        barVoidView.addSubview(barVoid!)
        barVoid!.centerInSuperview()
        barVoid!.width(to: barVoidView)
        barVoid!.height(to: barVoidView)
        barVoid!.setBarColor(uiColor: UIColor.from(.void))
        
        barAlpha = LevelBarView(frame: barAlphaView.frame, sideAlignment: .right)
        barAlphaView.addSubview(barAlpha!)
        barAlpha!.centerInSuperview()
        barAlpha!.width(to: barAlphaView)
        barAlpha!.height(to: barAlphaView)
        barAlpha!.setBarColor(uiColor: UIColor.from(.alpha))
        
        barOmega = LevelBarView(frame: barOmegaView.frame, sideAlignment: .left)
        barOmegaView.addSubview(barOmega!)
        barOmega!.centerInSuperview()
        barOmega!.width(to: barOmegaView)
        barOmega!.height(to: barOmegaView)
        barOmega!.setBarColor(uiColor: UIColor.from(.omega))
        
        barOrder = LevelBarView(frame: barOrderView.frame, sideAlignment: .right)
        barOrderView.addSubview(barOrder!)
        barOrder!.centerInSuperview()
        barOrder!.width(to: barOrderView)
        barOrder!.height(to: barOrderView)
        barOrder!.setBarColor(uiColor: UIColor.from(.order))
        
        barChaos = LevelBarView(frame: barChaosView.frame, sideAlignment: .left)
        barChaosView.addSubview(barChaos!)
        barChaos!.centerInSuperview()
        barChaos!.width(to: barChaosView)
        barChaos!.height(to: barChaosView)
        barChaos!.setBarColor(uiColor: UIColor.from(.chaos))
        
        barOne = LevelBarView(frame: barOneView.frame, sideAlignment: .right)
        barOneView.addSubview(barOne!)
        barOne!.centerInSuperview()
        barOne!.width(to: barOneView)
        barOne!.height(to: barOneView)
        barOne!.setBarColor(uiColor: UIColor.from(.mono))
        
        barMany = LevelBarView(frame: barManyView.frame, sideAlignment: .left)
        barManyView.addSubview(barMany!)
        barMany!.centerInSuperview()
        barMany!.width(to: barManyView)
        barMany!.height(to: barManyView)
        barMany!.setBarColor(uiColor: UIColor.from(.poly))
        
        
        barCorePotential = LevelBarView(frame: barCorePotentialView.frame, sideAlignment: .right)
        barCorePotentialView.addSubview(barCorePotential!)
        barCorePotential!.centerInSuperview()
        barCorePotential!.width(to: barCorePotentialView)
        barCorePotential!.height(to: barCorePotentialView)
        barCorePotential!.setBarColor(uiColor: UIColor.from(.core).withAlphaComponent(0.5))
        
        barAlphaPotential = LevelBarView(frame: barAlphaPotentialView.frame, sideAlignment: .right)
        barAlphaPotentialView.addSubview(barAlphaPotential!)
        barAlphaPotential!.centerInSuperview()
        barAlphaPotential!.width(to: barAlphaPotentialView)
        barAlphaPotential!.height(to: barAlphaPotentialView)
        barAlphaPotential!.setBarColor(uiColor: UIColor.from(.alpha).withAlphaComponent(0.5))
        
        barOrderPotential = LevelBarView(frame: barOrderPotentialView.frame, sideAlignment: .right)
        barOrderPotentialView.addSubview(barOrderPotential!)
        barOrderPotential!.centerInSuperview()
        barOrderPotential!.width(to: barOrderPotentialView)
        barOrderPotential!.height(to: barOrderPotentialView)
        barOrderPotential!.setBarColor(uiColor: UIColor.from(.order).withAlphaComponent(0.5))
        
        barVoidPotential = LevelBarView(frame: barVoidPotentialView.frame, sideAlignment: .left)
        barVoidPotentialView.addSubview(barVoidPotential!)
        barVoidPotential!.centerInSuperview()
        barVoidPotential!.width(to: barVoidPotentialView)
        barVoidPotential!.height(to: barVoidPotentialView)
        barVoidPotential!.setBarColor(uiColor: UIColor.from(.void).withAlphaComponent(0.5))
        
        barOmegaPotential = LevelBarView(frame: barOmegaPotentialView.frame, sideAlignment: .left)
        barOmegaPotentialView.addSubview(barOmegaPotential!)
        barOmegaPotential!.centerInSuperview()
        barOmegaPotential!.width(to: barOmegaPotentialView)
        barOmegaPotential!.height(to: barOmegaPotentialView)
        barOmegaPotential!.setBarColor(uiColor: UIColor.from(.omega).withAlphaComponent(0.5))
        
        barChaosPotential = LevelBarView(frame: barChaosPotentialView.frame, sideAlignment: .left)
        barChaosPotentialView.addSubview(barChaosPotential!)
        barChaosPotential!.centerInSuperview()
        barChaosPotential!.width(to: barChaosPotentialView)
        barChaosPotential!.height(to: barChaosPotentialView)
        barChaosPotential!.setBarColor(uiColor: UIColor.from(.chaos).withAlphaComponent(0.5))
        
        barSpiritPotential = LevelBarView(frame: barSpiritPotentialView.frame, sideAlignment: .left)
        barSpiritPotentialView.addSubview(barSpiritPotential!)
        barSpiritPotential!.centerInSuperview()
        barSpiritPotential!.width(to: barSpiritPotentialView)
        barSpiritPotential!.height(to: barSpiritPotentialView)
        barSpiritPotential!.setBarColor(uiColor: UIColor.from(.spirit).withAlphaComponent(0.5))
        
        barLightPotential = LevelBarView(frame: barLightPotentialView.frame, sideAlignment: .left)
        barLightPotentialView.addSubview(barLightPotential!)
        barLightPotential!.centerInSuperview()
        barLightPotential!.width(to: barLightPotentialView)
        barLightPotential!.height(to: barLightPotentialView)
        barLightPotential!.setBarColor(uiColor: UIColor.from(.light).withAlphaComponent(0.5))
        
        barShadowPotential = LevelBarView(frame: barShadowPotentialView.frame, sideAlignment: .left)
        barShadowPotentialView.addSubview(barShadowPotential!)
        barShadowPotential!.centerInSuperview()
        barShadowPotential!.width(to: barShadowPotentialView)
        barShadowPotential!.height(to: barShadowPotentialView)
        barShadowPotential!.setBarColor(uiColor: UIColor.from(.shadow).withAlphaComponent(0.5))
        
        barSoulPotential = LevelBarView(frame: barSoulPotentialView.frame, sideAlignment: .left)
        barSoulPotentialView.addSubview(barSoulPotential!)
        barSoulPotential!.centerInSuperview()
        barSoulPotential!.width(to: barSoulPotentialView)
        barSoulPotential!.height(to: barSoulPotentialView)
        barSoulPotential!.setBarColor(uiColor: UIColor.from(.soul).withAlphaComponent(0.5))
    }
    
    // MARK: Setup
    func setupRenderAnimation() {
        self.renderingProgressAnimation.image = UIImage.gifImageWithName("StarDiskFormation-loaderAnim_2")
        self.renderingProgressBar.isHidden = false
        self.renderingProgressLabel.isHidden = false
        self.renderingProgressSpinner.startAnimating()
    }
    
    func setupSpriteKitScene() {
        self.scene = SKScene(size: self.spriteKitView.frame.size)
        self.scene.backgroundColor = .clear
        self.scene.removeAllChildren()
        spriteKitView.presentScene(scene)
    }
    
    // Sprite Based Cosmic Disk
    func setupCosmicAlignmentSprite() {
        let spriteNode = CosmicAlignmentSpriteNode.create(size: scene.size)
        //spriteNode.color = .red
        spriteNode.position = spriteKitView.center
        self.scene.addChild(spriteNode)
    }
    
    // Sprite Based Planet Astrology Disk
    func setupPlanetPlacementSprite() {
        let starChart = StarChart.Core.current
        let selectedPlanets = StarChart.Core.selectedPlanets
        let spriteNode = PlanetaryPlacementsSpriteNode.create(starChart: starChart, selectedPlanets: selectedPlanets, size: scene.size)
        //spriteNode.color = .red
        spriteNode.position = spriteKitView.center
        self.scene.addChild(spriteNode)
    }
    
    func setupAspectLinesSprite() {
        let starChart = StarChart.Core.current
        let selectedPlanets = StarChart.Core.selectedPlanets
        let selectedAspects = StarChart.Core.selectedAspects
        let spriteNode = AspectLinesSpriteNode.create(starChart: starChart, selectedPlanets: selectedPlanets, size: scene.size)
        spriteNode.position = spriteKitView.center
        self.scene.addChild(spriteNode)
    }
    
    func setupTimeStreamVisualizer() {
        
        self.scene = SKScene(size: self.spriteKitView.frame.size)
        spriteKitView.presentScene(scene)
        
        let starChart = StarChart.Core.current
        let aspect = starChart.aspects.first!
        let testSprite = SpriteNodeCosmicEvent(aspect: aspect, primaryBodyLongitude: 0, secondaryBodyLongitude: 0, size: CGSize(width: 100, height: 100))!
        
        testSprite.position = CGPoint(x: self.scene.size.width/2, y: self.scene.size.height/2)
        
        scene.addChild(testSprite)
    }
}
