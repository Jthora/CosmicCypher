//
//  ResonanceReportViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/5/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation
import SwiftAA
import SpriteKit
import CoreGraphics
import TinyConstraints

class ResonanceReportViewController: UIViewController {
    
    static var current:ResonanceReportViewController? = nil
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "ResonanceReportViewController") as? ResonanceReportViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            // Presented
        }
        
    }
    
    
    // MARK: Bars
    // Bar View
    @IBOutlet weak var resonanceBarsView: UIView!
    
    @IBOutlet weak var barAirView: UIView!
    @IBOutlet weak var barFireView: UIView!
    @IBOutlet weak var barWaterView: UIView!
    @IBOutlet weak var barEarthView: UIView!
    
    @IBOutlet weak var barSpiritPotentialView: UIView!
    @IBOutlet weak var barSpiritView: UIView!
    @IBOutlet weak var barLightPotentialView: UIView!
    @IBOutlet weak var barLightView: UIView!
    @IBOutlet weak var barShadowPotentialView: UIView!
    @IBOutlet weak var barShadowView: UIView!
    @IBOutlet weak var barSoulPotentialView: UIView!
    @IBOutlet weak var barSoulView: UIView!
    
    @IBOutlet weak var barCorePotentialView: UIView!
    @IBOutlet weak var barCoreView: UIView!
    @IBOutlet weak var barAlphaPotentialView: UIView!
    @IBOutlet weak var barAlphaView: UIView!
    @IBOutlet weak var barOrderPotentialView: UIView!
    @IBOutlet weak var barOrderView: UIView!
    @IBOutlet weak var barVoidPotentialView: UIView!
    @IBOutlet weak var barVoidView: UIView!
    @IBOutlet weak var barOmegaPotentialView: UIView!
    @IBOutlet weak var barOmegaView: UIView!
    @IBOutlet weak var barChaosPotentialView: UIView!
    @IBOutlet weak var barChaosView: UIView!
    
    @IBOutlet weak var barOneView: UIView!
    @IBOutlet weak var barManyView: UIView!
    
    // levelBar
    var barAir: LevelBarView? = nil
    var barFire: LevelBarView? = nil
    var barWater: LevelBarView? = nil
    var barEarth: LevelBarView? = nil
    
    var barSpiritPotential: LevelBarView? = nil
    var barSpirit: LevelBarView? = nil
    var barLightPotential: LevelBarView? = nil
    var barLight: LevelBarView? = nil
    var barShadowPotential: LevelBarView? = nil
    var barShadow: LevelBarView? = nil
    var barSoulPotential: LevelBarView? = nil
    var barSoul: LevelBarView? = nil
    
    var barCorePotential: LevelBarView? = nil
    var barCore: LevelBarView? = nil
    var barAlphaPotential: LevelBarView? = nil
    var barAlpha: LevelBarView? = nil
    var barOrderPotential: LevelBarView? = nil
    var barOrder: LevelBarView? = nil
    var barVoidPotential: LevelBarView? = nil
    var barVoid: LevelBarView? = nil
    var barOmegaPotential: LevelBarView? = nil
    var barOmega: LevelBarView? = nil
    var barChaosPotential: LevelBarView? = nil
    var barChaos: LevelBarView? = nil
    
    var barOne: LevelBarView? = nil
    var barMany: LevelBarView? = nil
    
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
    
    // Bar Labels
    @IBOutlet weak var resonanceBarAirLabel: UILabel!
    @IBOutlet weak var resonanceBarFireLabel: UILabel!
    @IBOutlet weak var resonanceBarWaterLabel: UILabel!
    @IBOutlet weak var resonanceBarEarthLabel: UILabel!
    @IBOutlet weak var resonanceBarSpiritLabel: UILabel!
    @IBOutlet weak var resonanceBarLightLabel: UILabel!
    @IBOutlet weak var resonanceBarShadowLabel: UILabel!
    @IBOutlet weak var resonanceBarSoulLabel: UILabel!
    @IBOutlet weak var resonanceBarCoreLabel: UILabel!
    @IBOutlet weak var resonanceBarAlphaLabel: UILabel!
    @IBOutlet weak var resonanceBarOrderLabel: UILabel!
    @IBOutlet weak var resonanceBarMonoLabel: UILabel!
    @IBOutlet weak var resonanceBarVoidLabel: UILabel!
    @IBOutlet weak var resonanceBarOmegaLabel: UILabel!
    @IBOutlet weak var resonanceBarChaosLabel: UILabel!
    @IBOutlet weak var resonanceBarPolyLabel: UILabel!
    
    // Modality Numbers
    @IBOutlet weak var cardinalNumberLabel: UILabel!
    @IBOutlet weak var fixedNumberLabel: UILabel!
    @IBOutlet weak var mutableNumberLabel: UILabel!
    
    // Discernment Graph
    @IBOutlet weak var discernmentGraphView: UIView!
    
    // Modality Indicators
    // Fire
    @IBOutlet weak var modalityIndicatorLeo: UIImageView!
    @IBOutlet weak var modalityIndicatorAries: UIImageView!
    @IBOutlet weak var modalityIndicatorSagittarius: UIImageView!
    // Air
    @IBOutlet weak var modalityIndicatorLibra: UIImageView!
    @IBOutlet weak var modalityIndicatorAquarius: UIImageView!
    @IBOutlet weak var modalityIndicatorGemini: UIImageView!
    // Water
    @IBOutlet weak var modalityIndicatorCancer: UIImageView!
    @IBOutlet weak var modalityIndicatorScorpio: UIImageView!
    @IBOutlet weak var modalityIndicatorPisces: UIImageView!
    // Earth
    @IBOutlet weak var modalityIndicatorCapricorn: UIImageView!
    @IBOutlet weak var modalityIndicatorTaurus: UIImageView!
    @IBOutlet weak var modalityIndicatorVirgo: UIImageView!
    
    // StarChart Rendering
    @IBOutlet weak var renderingProgressBar: UIProgressView!
    @IBOutlet weak var renderingProgressSpinner: UIActivityIndicatorView!
    @IBOutlet weak var renderingProgressLabel: UILabel!
    @IBOutlet weak var renderingProgressAnimation: UIImageView!
    
    // TimeStream Loading
    @IBOutlet weak var loadingTimeStreamsSpinner: UIActivityIndicatorView!
    
    // Central UI Elements
    @IBOutlet weak var dateTimeCoordsLabel: UILabel!
    
    @IBOutlet weak var geoLocationButton: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var planetSelectButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    var isLive:Bool = false {
        didSet {
//            if isLive && readingUpdateTimer == nil {
//                readingUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
//                    self.currentStarChart = StarChart(date: Date())
//                    self.update()
//                }
//            } else {
//                readingUpdateTimer?.invalidate()
//                readingUpdateTimer = nil
//            }
        }
    }
    var readingUpdateTimer:Timer? = nil
    
    
    
    @IBOutlet weak var spriteKitView: SKView!
    var scene:SKScene = SKScene(size: CGSize(width: 512, height: 512))
    
    @IBOutlet weak var aspectsResultsTableView: UITableView!
    @IBOutlet weak var timeStreamTableView: UITableView!
    
    var discernmentCentralPoint:CAShapeLayer? = nil
    var discernmentCentralBlob:CAShapeLayer? = nil
    var discernmentOuterBlob:CAShapeLayer? = nil
    
    var degreeOffset:Degree = 0
    
    
    // MARK: View Event Responders
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ResonanceReportViewController.current = self
        
        // Do any additional setup after loading the view.
        aspectsResultsTableView.delegate = self
        aspectsResultsTableView.dataSource = self
        timeStreamTableView.delegate = self
        timeStreamTableView.dataSource = self
        
        TimeStream.Core.add(reactive: self)
        StarChart.Core.add(reactive: self)
        
        setup()
        
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        resetEnergyLevels()
        ResonanceReportViewController.current = self
    }
    
    // View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        isLive = true
        animateBarLabels()
        update()
    }
    
    
    // MARK: Setup
    // Setup
    func setup() {
        //setupTimeStreamVisualizer()
        //setupCosmicAlignmentSprite()
        setupBars()
        setupSpriteKitScene()
        setupRenderAnimation()
        resetEnergyLevels()
        update()
        renderStarChart()
    }
    
    // Display/Hide Bar Labels
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
    
    func setStarChart(date:Date, coordinates:GeographicCoordinates? = nil) {
        StarChart.Core.current = StarChart(date: date, coordinates: coordinates)
    }
    
    // MARK: Update
    // Update
    func update() {
        updateWithOperation()
    }
    
    // Update using Update Operation Queue
    func updateWithOperation() {
        _updateOperationQueue.cancelAllOperations()
        _updateOperationQueue.addOperation(ResonanceReportUpdateOperation(self))
    }
    
    // Update Dispatch Queue
    fileprivate var _updateQueue:DispatchQueue = DispatchQueue(label: "_updateQueue")
    
    // Update Operation Queue
    private let _updateOperationQueue: OperationQueue = {
        let op = OperationQueue()
        op.isSuspended = false
        return op
    } ()
    
    // Update Operation
    class ResonanceReportUpdateOperation: Operation {
        
        var vc: ResonanceReportViewController
        init(_ vc:ResonanceReportViewController) {
            self.vc = vc
        }
        
        // Run Update Operation Function
        override func main() {

            // Update on Main Thread
            if isCancelled { return }
            DispatchQueue.main.async {

                /// Current StarChart and Details
                let starChart = StarChart.Core.current
                let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)

                /// Text Fields
                self.vc.dateTimeCoordsLabel.text = "Latitude: \(starChart.coordinates.latitude)\nLongitude: \(-starChart.coordinates.longitude)\nDate: \(starChart.date.formatted(date: .numeric, time: .omitted))\nTime: \(starChart.date.formattedTime(for: starChart.coordinates))"
                self.vc.aspectsResultsTableView.reloadData()

                /// Energy Levels
                self.vc.updateEnergyLevels(starChart:starChart)

                /// Modality Meters
                self.vc.updateModalityMeters(starChart:starChart)

                /// Discernment Chart
                if self.isCancelled { return }
                self.vc._updateQueue.async {

                    /// Central Point
                    DispatchQueue.main.async {
                        if self.isCancelled { return }
                        guard let cp = self.vc.createDiscernmentCentralPoint() else {return}
                        if self.isCancelled { return }
                        self.vc.discernmentCentralPoint?.removeFromSuperlayer()
                        self.vc.discernmentCentralPoint = nil
                        self.vc.discernmentCentralPoint = cp
                        self.vc.discernmentGraphView.layer.addSublayer(self.vc.discernmentCentralPoint!)
                    }

                    /// Central Circle
                    DispatchQueue.main.async {
                        guard let dcb = self.vc.createDiscernmentCentralGraphZone() else {return}
                        if self.isCancelled { return }
                        self.vc.discernmentCentralBlob?.removeFromSuperlayer()
                        self.vc.discernmentCentralBlob = nil
                        self.vc.discernmentCentralBlob = dcb
                        self.vc.discernmentGraphView.layer.addSublayer(self.vc.discernmentCentralBlob!)
                    }

                    /// Outer Circle
                    DispatchQueue.main.async {
                        if self.isCancelled { return }
                        guard let dob = self.vc.createDiscernmentOuterGraphZone() else {return}
                        if self.isCancelled { return }
                        self.vc.discernmentOuterBlob?.removeFromSuperlayer()
                        self.vc.discernmentOuterBlob = nil
                        self.vc.discernmentOuterBlob = dob
                        self.vc.discernmentGraphView.layer.addSublayer(self.vc.discernmentOuterBlob!)
                    }


                }

            }
        }
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
    
    func setupCosmicAlignmentSprite() {
        let spriteNode = CosmicAlignmentSpriteNode.create(size: scene.size)
        //spriteNode.color = .red
        spriteNode.position = spriteKitView.center
        scene.addChild(spriteNode)
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
    
    // TODO: Update TimeStream Visualizer
    func updateTimeStreamVisualizer() {
        
    }
    
    
    
    
    // MARK: Discernment Graph
    // Outer Cirlce
    func createDiscernmentOuterGraphZone() -> CAShapeLayer? {
        
        let selectedAspectBodies = StarChart.Core.selectedNodeTypes
        guard selectedAspectBodies.count > 1 else { return nil }
        
        let maxExaltation:Double = StarChart.Core.maxExaltation
        let maxDebilitation:Double = StarChart.Core.maxDebilitation
        let maxRise:Double = StarChart.Core.maxRise
        let maxFall:Double = StarChart.Core.maxFall
        
        guard !maxExaltation.isNaN && !maxDebilitation.isNaN && !maxRise.isNaN && !maxFall.isNaN else { return nil }
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var x:Double = ((1-maxDebilitation) * graphHalfSize)
        let width:Double = (maxExaltation + maxDebilitation) * graphHalfSize
        var y:Double = ((1-maxFall) * graphHalfSize)
        let height:Double = (maxRise + maxFall) * graphHalfSize
        
        if Int(x) == Int(graphHalfSize) && width < 4 {
            x = graphHalfSize-2
        }
        if Int(y) == Int(graphHalfSize) && height < 4 {
            y = graphHalfSize-2
        }
        
        let rect = CGRect(x: x, y: y, width: max(4,width), height: max(4,height))
        
        let blobPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(min(width/2, height/2)))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blobPath.cgPath
        shapeLayer.compositingFilter = CompositingFilterStrings.overlayBlendMode.rawValue
        
        
        shapeLayer.anchorPoint = discernmentGraphView.center
        
        // ROTATE TRANSFORM!
        //shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Degree(45).inRadians.value), 0.0, 0.0, 1.0)

        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 1.0

        return shapeLayer
    }
    
    // Central Cirlce
    func createDiscernmentCentralGraphZone() -> CAShapeLayer? {
        
        let selectedPlanets = StarChart.Core.selectedPlanets
        guard selectedPlanets.count > 1 else { return nil }
        
        let maxExaltation:Double = StarChart.Core.maxExaltation
        let maxDebilitation:Double = StarChart.Core.maxDebilitation
        let maxRise:Double = StarChart.Core.maxRise
        let maxFall:Double = StarChart.Core.maxFall
        
        guard !maxExaltation.isNaN && !maxDebilitation.isNaN && !maxRise.isNaN && !maxFall.isNaN else { return nil }
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var x:Double = ((1-maxDebilitation) * graphHalfSize)
        let width:Double = (maxDebilitation + maxExaltation) * graphHalfSize
        var y:Double = ((1-maxFall) * graphHalfSize)
        let height:Double = (maxFall + maxRise) * graphHalfSize
        
        if x == 0 && width < 4 {
            x = -2
        }
        if y == 0 && height < 4 {
            y = -2
        }
        
        let rect = CGRect(x: x, y: y, width: max(4,width), height: max(4,height))
        
        let blobPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(min(width/2, height/2)))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blobPath.cgPath
        shapeLayer.compositingFilter = CompositingFilterStrings.overlayBlendMode.rawValue
        
        
        shapeLayer.anchorPoint = discernmentGraphView.center
        
        // ROTATE TRANSFORM!
        //shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Degree(45).inRadians.value), 0.0, 0.0, 1.0)

        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        shapeLayer.lineWidth = 2.0

        return shapeLayer
    }
    
    // Central Point
    func createDiscernmentCentralPoint() -> CAShapeLayer? {
        
        let selectedAspectBodies = StarChart.Core.selectedNodeTypes
        guard selectedAspectBodies.count > 1 else { return nil }
        
        let averageExaltation:Double = StarChart.Core.averageExaltation
        let averageDebilitation:Double = StarChart.Core.averageDebilitation
        let averageRise:Double = StarChart.Core.averageRise
        let averageFall:Double = StarChart.Core.averageFall
        
        guard !averageExaltation.isNaN && !averageDebilitation.isNaN && !averageRise.isNaN && !averageFall.isNaN else { return nil }
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var exa = averageExaltation-averageDebilitation
        var rise = averageRise-averageFall
        
        exa *= graphHalfSize
        rise *= graphHalfSize
        exa += graphHalfSize
        rise += graphHalfSize
        
        let x:Double = exa - 4
        let width:Double = 8
        let y:Double = rise - 4
        let height:Double = 8
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let blobPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(min(width/2, height/2)))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blobPath.cgPath
        shapeLayer.compositingFilter = CompositingFilterStrings.overlayBlendMode.rawValue
        
        
        shapeLayer.anchorPoint = discernmentGraphView.center
        
        // ROTATE TRANSFORM!
        //shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Degree(45).inRadians.value), 0.0, 0.0, 1.0)

        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
        shapeLayer.lineWidth = 2.0

        return shapeLayer
    }
    
    // MARK: Buttons
    @IBAction func settingsButtonTouch(_ sender: UIButton) {
        //TimeStreamSettingsViewController.presentModally(over: self)
        SettingsViewController.presentModally(over: self)
    }
    
    @IBAction func instructionsButtonTouch(_ sender: UIButton) {
        CosmicCypherInstructionsViewController.presentModally(over: self)
    }
    
    @IBAction func planetSelectButtonTouch(_ sender: UIButton) {
        PlanetSelectViewController.presentModally(over: self)
    }
    
    @IBAction func geoLocationButtonTouch(_ sender: UIButton) {
        StarChartSelectViewController.presentModally(over: self)
    }
    
    
    @IBAction func barsTouched(_ sender: UIButton) {
        ElementalReadingViewController.presentModally(over: self)
    }
    
    
    @IBAction func shareButtonTouch(_ sender: UIButton) {
        DispatchQueue.main.async {
            //Set the default sharing message.
            let message = "Cosmic Cypher App"
            let link = NSURL(string: "https://cosmiccypher.app/")
            // Screenshot:
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
            self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            //Set the link, message, image to share.
            if let link = link, let img = img {
                let objectsToShare = [message,link,img] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            } else {
                print("Error: Set the link, message, image to share not working...")
            }
        }
        
    }
    
    // MARK: UI Controls
    private var _hideCentralUI:Bool = false
    func toggleCentralUI(animate:Bool = true) {
        DispatchQueue.main.async {
            self._hideCentralUI = !self._hideCentralUI
            if animate {
                if self._hideCentralUI {
                    UIView.animate(withDuration: 0.5) {
                        self.dateTimeCoordsLabel.alpha = 0
                        self.geoLocationButton.alpha = 0
                        self.instructionsButton.alpha = 0
                        self.planetSelectButton.alpha = 0
                        self.settingsButton.alpha = 0
                        self.shareButton.alpha = 0
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.dateTimeCoordsLabel.alpha = 1
                        self.geoLocationButton.alpha = 1
                        self.instructionsButton.alpha = 1
                        self.planetSelectButton.alpha = 1
                        self.settingsButton.alpha = 1
                        self.shareButton.alpha = 1
                    }
                }
            } else {
                if self._hideCentralUI {
                    self.dateTimeCoordsLabel.alpha = 0
                    self.geoLocationButton.alpha = 0
                    self.instructionsButton.alpha = 0
                    self.planetSelectButton.alpha = 0
                    self.settingsButton.alpha = 0
                    self.shareButton.alpha = 0
                } else {
                    self.dateTimeCoordsLabel.alpha = 1
                    self.geoLocationButton.alpha = 1
                    self.instructionsButton.alpha = 1
                    self.planetSelectButton.alpha = 1
                    self.settingsButton.alpha = 1
                    self.shareButton.alpha = 1
                }
            }
        }
    }
    
    // MARK: Gesture Recognizers
    // Tap on Main Screen
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        toggleCentralUI(animate: true)
    }
    
    @IBAction func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        sender.translation(in: spriteKitView)
        sender.velocity(in: spriteKitView)
        
        // use start vs current position from around scene center point to calculate angle offset for time of year.
    }
    
    @IBAction func longPressGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        // Reset to original position
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
    
}

// MARK: UITableView Delegate and DataSource
extension ResonanceReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == aspectsResultsTableView {
            return StarChart.Core.current.sortedAspects(selectedNodeTypes: StarChart.Core.selectedNodeTypes,
                                                       selectedAspects: StarChart.Core.selectedAspects).count
        } else if tableView == self.timeStreamTableView {
            return TimeStream.Core.compositeCount + 1 //currentComposites.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == aspectsResultsTableView {
            guard let cell = aspectsResultsTableView.dequeueReusableCell(withIdentifier: "ResonanceReportTableViewCell") as? ResonanceReportTableViewCell else { return UITableViewCell() }
            
            let aspects = StarChart.Core.sortedAspects
            guard indexPath.row < aspects.count else {return UITableViewCell()}
            let aspect = aspects[indexPath.row]
            guard let pLong = StarChart.Core.current.alignments[aspect.primaryBody.type]?.longitude,
                  let sLong = StarChart.Core.current.alignments[aspect.secondaryBody.type]?.longitude else { return cell }
            
            cell.setup(with: aspect, primaryBodyLongitude: pLong, secondaryBodyLongitude: sLong)
            
            return cell
            
        } else if tableView == timeStreamTableView {
            // Add New Cell
            if indexPath.row >= TimeStream.Core.compositeCount {
                guard let cell = timeStreamTableView.dequeueReusableCell(withIdentifier: "TimeStreamAddNewCompositeTableViewCell") as? TimeStreamAddNewCompositeTableViewCell else {
                    let cell = TimeStreamAddNewCompositeTableViewCell()
                    return cell
                }
                return cell
            }
            
            // Existing TimeStream Cell
            guard let cell = timeStreamTableView.dequeueReusableCell(withIdentifier: "TimeStreamCompositeTableViewCell") as? TimeStreamCompositeTableViewCell else {
                let cell = TimeStreamCompositeTableViewCell()
                
                cell.timeStreamComposite = TimeStream.Core.composite(for: indexPath)
                cell.uuid = TimeStream.Core.compositeUUID(for: indexPath)
                cell.update()
                
                return cell
            }
            
            cell.timeStreamComposite = TimeStream.Core.composite(for: indexPath)
            cell.uuid = TimeStream.Core.compositeUUID(for: indexPath)
            cell.update()
            /// Setup TimeStream Visualization
            /// Composites
            /// SpriteNodes
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == timeStreamTableView {
            if indexPath.row >= TimeStream.Core.compositeCount {
                // Add New Timestream
                TimeStreamSelectViewController.presentModally(over: self)
                return
            } else if let cell = tableView.cellForRow(at: indexPath) as? TimeStreamCompositeTableViewCell,
                      let planets = cell.timeStreamComposite?.configuration.nodeTypes {
                DispatchQueue.main.async {
                    StarChart.Core.selectedNodeTypes = planets
                    let point = cell.currentPoint
                    StarChart.Core.current = StarChartRegistry.main.getStarChart(point: point!)
                    ResonanceReportViewController.current?.update()
                    self.update()
                }
            }
        } else if tableView == timeStreamTableView {
            print("Harmonics Report Selected: \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == timeStreamTableView {
            if indexPath.row >= TimeStream.Core.compositeCount {
                return 2*tableView.frame.size.height/3
            }
            return tableView.frame.size.height
        } else if tableView == aspectsResultsTableView {
            return tableView.contentSize.width
        } else {
            return tableView.rowHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == timeStreamTableView {
            /// Update Data Model
            ///
            /// Reference TimeStreamCore for Centralized Data Model - single source of truth
//            let mover = currentTimeStreams.remove(at: sourceIndexPath.row)
//            currentTimeStreams.insert(mover, at: destinationIndexPath.row)
        }
    }
//
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == timeStreamTableView { // TimeStream Composite
            /// TimeStream Composite Cell
            let contextItemEdit = UIContextualAction(style: .normal, title: " Edit \n🛠 ") {  (contextualAction, view, boolValue) in
                /// Duplicate TimeStream Composite
                TimeStreamSettingsViewController.presentModally(over: self)

                // TODO: Pre-Focus on Edited TimeStream Composite
            }
            let contextItemDelete = UIContextualAction(style: .destructive, title: " Delete \n✖️ ") {  (contextualAction, view, boolValue) in
                /// Delete TimeStream Composite
                //TimeStreamCore.deleteTimeStreamComposite()
                guard let cell = tableView.cellForRow(at: indexPath) as? TimeStreamCompositeTableViewCell,
                      let composite = cell.timeStreamComposite else {
                    print("ERROR: missing composite for delete swipe action")
                    return
                }
                TimeStream.Core.delete(timeStreamComposite: composite)
                DispatchQueue.main.async {
                    ResonanceReportViewController.current?.timeStreamTableView.reloadData()
                }
            }
            return UISwipeActionsConfiguration(actions: [contextItemEdit, contextItemDelete])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if tableView == timeStreamTableView {
//            /// TimeStream Composite Cell
//            let contextItemDelete = UIContextualAction(style: .destructive, title: " Delete \n✖️ ") {  (contextualAction, view, boolValue) in
//                /// Delete TimeStream Composite
//                //TimeStreamCore.deleteTimeStreamComposite()
//                guard let cell = tableView.cellForRow(at: indexPath) as? TimeStreamCompositeTableViewCell,
//                      let composite = cell.timeStreamComposite else {
//                    print("ERROR: missing composite for delete swipe action")
//                    return
//                }
//
//                TimeStream.Core.delete(timeStreamComposite: composite)
//            }
//            return UISwipeActionsConfiguration(actions: [contextItemDelete])
//        } else {
//            return UISwipeActionsConfiguration(actions: [])
//        }
//    }

    
    
    
}



extension ResonanceReportViewController: TimeStreamCoreReactive {
    func timeStreamCore(didAction action: TimeStream.Core.Action) {
        switch action {
        case .update(let updateAction):
            switch updateAction {
            case .composites:
                DispatchQueue.main.async {
                    self.timeStreamTableView.reloadData()
                    self.loadingTimeStreamsSpinner.stopAnimating()
                }
            }
        case .onLoadTimeStream(loadTimeStreamAction: let loadTimeStreamAction):
            switch loadTimeStreamAction {
                
            case .progress(completion: let completion):
                break
            case .complete:
                break
            case .start(uuid: let uuid, name: let name, configuration: let configuration):
                self.timeStreamTableView.reloadData()
                self.loadingTimeStreamsSpinner.startAnimating()
                break
            }
        }
    }
}

extension ResonanceReportViewController: StarChartCoreReactive {
    func starChartCore(didAction action: StarChart.Core.Action) {
        switch action {
        case .renderStart:
            DispatchQueue.main.async {
                print("renderStart")
                self.renderingProgressBar.isHidden = false
                self.renderingProgressSpinner.isHidden = false
                self.renderingProgressLabel.isHidden = false
                self.renderingProgressAnimation.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.renderingProgressBar.alpha = 1
                    self.renderingProgressSpinner.alpha = 1
                    self.renderingProgressLabel.alpha = 1
                    self.renderingProgressAnimation.alpha = 1
                } completion: { _ in
                }
            }
            break
        case .renderProgress(let percentageCompleted):
            DispatchQueue.main.async {
                print("renderProgress")
                self.renderingProgressBar.progress = percentageCompleted
            }
        case .renderComplete(let spriteNode):
            DispatchQueue.main.async {
                print("renderComplete")
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.renderingProgressBar.alpha = 0
                    self.renderingProgressSpinner.alpha = 0
                    self.renderingProgressLabel.alpha = 0
                    self.renderingProgressAnimation.alpha = 0
                } completion: { _ in
                    self.renderingProgressBar.isHidden = true
                    self.renderingProgressSpinner.isHidden = true
                    self.renderingProgressLabel.isHidden = true
                    self.renderingProgressAnimation.isHidden = true
                }
                
                self.scene.backgroundColor = .black
                self.scene.removeAllChildren()
                self.scene.addChild(spriteNode)
                self.spriteKitView.presentScene(self.scene)
                
                self.update()
            }
        case .renderStop:
            DispatchQueue.main.async {
                print("renderStop")
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.renderingProgressBar.alpha = 0
                    self.renderingProgressSpinner.alpha = 0
                    self.renderingProgressLabel.alpha = 0
                    self.renderingProgressAnimation.alpha = 0
                } completion: { _ in
                    self.renderingProgressBar.isHidden = true
                    self.renderingProgressSpinner.isHidden = true
                    self.renderingProgressLabel.isHidden = true
                    self.renderingProgressAnimation.isHidden = true
                }
            }
        }
    }
    
    func renderStarChart() {
        StarChart.Core.renderStarChart(size: scene.size)
    }
}

// TODO: Drag and Drop Support

// will require timeStreamAddNewCompositeRow reference

//// MARK: DRAG
//extension ResonanceReportViewController: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        if tableView == timeStreamTableView {
//
//            if indexPath.row == timeStreamAddNewCompositeRow {
//                // ADD
//                return []
//            } else {
//                // DRAG
//                let hashString:String = TimeStream.Core.currentComposites[indexPath.row].hashKey
//                guard let data = hashString.data(using: .utf8) else { return [] }
//                let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "app.cosmiccypher.timestreamcomposite")
//                let dragItem = UIDragItem(itemProvider: itemProvider)
//                //dragItem.localObject = data[indexPath.row] // TimeStream
//                return [ dragItem ]
//            }
//        } else if tableView == timeStreamConfigurationTableView {
//            if indexPath.row == timeStreamAddNewRow {
//                // ADD
//                return []
//            } else {
//                // DRAG
//                let string = "timestream x"//currentTimeStreams[indexPath.row]
//                guard let data = string.data(using: .utf8) else { return [] }
//                let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: "app.cosmiccypher.timestream")
//                let dragItem = UIDragItem(itemProvider: itemProvider)
//                //dragItem.localObject = data[indexPath.row] // TimeStream
//                return [ dragItem ]
//            }
//        } else {
//            return []
//        }
//    }
//
//
//}
//
//// MARK: DROP
//extension TimeStreamSettingsViewController: UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//
//        let destinationIndexPath: IndexPath
//
//        if tableView == timeStreamCompositeTableView {
//
//            if let indexPath = coordinator.destinationIndexPath {
//                destinationIndexPath = indexPath
//            } else {
//                let section = tableView.numberOfSections - 1
//                let row = tableView.numberOfRows(inSection: section)
//                destinationIndexPath = IndexPath(row: row, section: section)
//            }
//
////            guard timeStreamAddNewCompositeRow != destinationIndexPath.row else {
////                return
////            }
//
//            // attempt to load strings from the drop coordinator
//            coordinator.session.loadObjects(ofClass: NSString.self) { items in
//                // convert the item provider array to a string array or bail out
//                guard let strings = items as? [String] else { return }
//
//                // create an empty array to track rows we've copied
//                var indexPaths = [IndexPath]()
//
//                // loop over all the strings we received
//                for (index, string) in strings.enumerated() {
//                    // create an index path for this new row, moving it down depending on how many we've already inserted
//                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//
//                    // insert the copy into the correct array
////                    TimeStreamCompositeRegistry.main.hashList.insert(string, at: indexPath.row)
////                    TimeStream.Core.currentComposites[indexPath.row].hashKey
//
//                    // keep track of this new row
//                    indexPaths.append(indexPath)
//                }
//
//                // insert them all into the table view at once
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            }
//        } else if tableView == timeStreamConfigurationTableView {
//
//            if let indexPath = coordinator.destinationIndexPath {
//                destinationIndexPath = indexPath
//            } else {
//                let section = tableView.numberOfSections - 1
//                let row = tableView.numberOfRows(inSection: section)
//                destinationIndexPath = IndexPath(row: row, section: section)
//            }
//
////            guard timeStreamAddNewRow != destinationIndexPath.row else {
////                return
////            }
//
//            // attempt to load strings from the drop coordinator
//            coordinator.session.loadObjects(ofClass: NSString.self) { items in
//                // convert the item provider array to a string array or bail out
//                guard let strings = items as? [String] else { return }
//
//                // create an empty array to track rows we've copied
//                var indexPaths = [IndexPath]()
//
//                // loop over all the strings we received
//                for (index, string) in strings.enumerated() {
//                    // create an index path for this new row, moving it down depending on how many we've already inserted
//                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//
//                    // insert the copy into the correct array
////                    self.currentTimeStreams.insert(string, at: indexPath.row)
//
//                    // keep track of this new row
//                    indexPaths.append(indexPath)
//                }
//
//                // insert them all into the table view at once
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            }
//        } else {
//        }
//    }
//
//}
