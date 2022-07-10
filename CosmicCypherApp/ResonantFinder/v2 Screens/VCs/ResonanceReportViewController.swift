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
    
    
    @IBOutlet weak var resonanceBarsView: UIView!
    
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
    
    
    
    
    // Power Bars
    @IBOutlet weak var powerBarAir: UIProgressView!
    @IBOutlet weak var powerBarFire: UIProgressView!
    @IBOutlet weak var powerBarWater: UIProgressView!
    @IBOutlet weak var powerBarEarth: UIProgressView!
    @IBOutlet weak var powerBarCore: UIProgressView!
    @IBOutlet weak var powerBarAlpha: UIProgressView!
    @IBOutlet weak var powerBarOne: UIProgressView!
    @IBOutlet weak var powerBarNegative: UIProgressView!
    @IBOutlet weak var shadowBarTop: UIProgressView!
    @IBOutlet weak var shadowBarHoly: UIProgressView!
    @IBOutlet weak var shadowBarEvil: UIProgressView!
    @IBOutlet weak var shadowBarBottom: UIProgressView!
    @IBOutlet weak var shadowBarVoid: UIProgressView!
    @IBOutlet weak var shadowBarOmega: UIProgressView!
    @IBOutlet weak var shadowBarMany: UIProgressView!
    @IBOutlet weak var shadowBarPositive: UIProgressView!
    
    // Potential Bars
    @IBOutlet weak var potentialBarCore: UIProgressView!
    @IBOutlet weak var potentialBarAlpha: UIProgressView!
    @IBOutlet weak var potentialBarOrder: UIProgressView!
    @IBOutlet weak var potentialBarNether: UIProgressView!
    @IBOutlet weak var potentialBarSpirit: UIProgressView!
    @IBOutlet weak var potentialBarLight: UIProgressView!
    @IBOutlet weak var potentialBarShadow: UIProgressView!
    @IBOutlet weak var potentialBarSoul: UIProgressView!
    @IBOutlet weak var potentialBarVoid: UIProgressView!
    @IBOutlet weak var potentialBarOmega: UIProgressView!
    @IBOutlet weak var potentialBarChaos: UIProgressView!
    @IBOutlet weak var potentialBarAether: UIProgressView!
    
    // 
    
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
        
        //setupTimeStreamVisualizer()
        //setupCosmicAlignmentSprite()
        setupSpriteKitScene()
        setupRenderAnimation()
        update()
        renderStarChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ResonanceReportViewController.current = self
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLive = true
        animateBarLabels()
        update()
    }
    
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
    
    func update() {
        DispatchQueue.main.async {
            
            let starChart = StarChart.Core.current
            let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)
            
            self.dateTimeCoordsLabel.text = "Latitude: \(starChart.coordinates.latitude)\nLongitude: \(-starChart.coordinates.longitude)\nDate: \(starChart.date.formatted(date: .numeric, time: .omitted))\nTime: \(starChart.date.formattedTime(for: starChart.coordinates))"
            
            self.aspectsResultsTableView.reloadData()
            self.updatePowerBars(starChart:starChart)
            self.updateModalityMeters(starChart:starChart)
            
            DispatchQueue.global().async {
                guard let dcb = self.createDiscernmentCentralGraphZone() else {return}
                DispatchQueue.main.async {
                    self.discernmentCentralBlob?.removeFromSuperlayer()
                    self.discernmentCentralBlob = nil
                    self.discernmentCentralBlob = dcb
                    self.discernmentGraphView.layer.addSublayer(self.discernmentCentralBlob!)
                }
                
                guard let dob = self.createDiscernmentOuterGraphZone() else {return}
                DispatchQueue.main.async {
                    self.discernmentOuterBlob?.removeFromSuperlayer()
                    self.discernmentOuterBlob = nil
                    self.discernmentOuterBlob = dob
                    self.discernmentGraphView.layer.addSublayer(self.discernmentOuterBlob!)
                }
                
                guard let cp = self.createDiscernmentCentralPoint() else {return}
                DispatchQueue.main.async {
                    self.discernmentCentralPoint?.removeFromSuperlayer()
                    self.discernmentCentralPoint = nil
                    self.discernmentCentralPoint = cp
                    self.discernmentGraphView.layer.addSublayer(self.discernmentCentralPoint!)
                }
            }
            
        }
    }
    
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
    
    func updateTimeStreamVisualizer() {
        
    }
    
    
    
    
    // MARK: MAX
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
    
    // MARK: Min
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
    
    // MARK: Average
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
    
    
    @IBAction func shareButtonTouch(_ sender: UIButton) {
        DispatchQueue.main.async {
            //Set the default sharing message.
            let message = "Cosmic Cypher App"
            let link = NSURL(string: "https://cosmiccypher.thora.tech/")
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
    
    @IBAction func tapOnPowerBars(_ sender: Any) {
        // Switch between two modes
        // Mode 1: Elements and Forces values are Blended: to better show spread of
        // Mode 2: Elements and Forces are discretely placed between each other: so to be more specific about where powers are distributed
        
        // TODO:: Mode 3+: Natura Disk Display
    }
    
    func updatePowerBars(starChart:StarChart) {
        
        let cosmicAlignment = StarChart.Core.currentCosmicAlignment
        
        powerBarAir.setProgress(Float(cosmicAlignment.level(.air, .baseline)), animated: true)
        powerBarFire.setProgress(Float(cosmicAlignment.level(.fire, .baseline)), animated: true)
        powerBarWater.setProgress(Float(cosmicAlignment.level(.water, .baseline)), animated: true)
        powerBarEarth.setProgress(Float(cosmicAlignment.level(.earth, .baseline)), animated: true)
        
        shadowBarTop.setProgress(Float(cosmicAlignment.level(.spirit, .baseline)), animated: true)
        shadowBarHoly.setProgress(Float(cosmicAlignment.level(.light, .baseline)), animated: true)
        shadowBarEvil.setProgress(Float(cosmicAlignment.level(.shadow, .baseline)), animated: true)
        shadowBarBottom.setProgress(Float(cosmicAlignment.level(.soul, .baseline)), animated: true)
        
        powerBarCore.setProgress(Float(cosmicAlignment.level(.core, .baseline)), animated: true)
        powerBarAlpha.setProgress(Float(cosmicAlignment.level(.alpha, .baseline)), animated: true)
        powerBarOne.setProgress(Float(cosmicAlignment.level(.order, .baseline)), animated: true)
        powerBarNegative.setProgress(Float(cosmicAlignment.level(.mono, .baseline)), animated: true)
        
        shadowBarVoid.setProgress(Float(cosmicAlignment.level(.void, .baseline)), animated: true)
        shadowBarOmega.setProgress(Float(cosmicAlignment.level(.omega, .baseline)), animated: true)
        shadowBarMany.setProgress(Float(cosmicAlignment.level(.chaos, .baseline)), animated: true)
        shadowBarPositive.setProgress(Float(cosmicAlignment.level(.poly, .baseline)), animated: true)
        
        
        potentialBarCore.setProgress(Float(cosmicAlignment.level(.core, .potential)), animated: true)
        potentialBarAlpha.setProgress(Float(cosmicAlignment.level(.alpha, .potential)), animated: true)
        potentialBarOrder.setProgress(Float(cosmicAlignment.level(.order, .potential)), animated: true)
        potentialBarNether.setProgress(Float(cosmicAlignment.level(.mono, .potential)), animated: true)
        potentialBarSpirit.setProgress(Float(cosmicAlignment.level(.spirit, .potential)), animated: true)
        potentialBarLight.setProgress(Float(cosmicAlignment.level(.light, .potential)), animated: true)
        potentialBarShadow.setProgress(Float(cosmicAlignment.level(.shadow, .potential)), animated: true)
        potentialBarSoul.setProgress(Float(cosmicAlignment.level(.soul, .potential)), animated: true)
        
        potentialBarVoid.setProgress(Float(cosmicAlignment.level(.void, .potential)), animated: true)
        potentialBarOmega.setProgress(Float(cosmicAlignment.level(.omega, .potential)), animated: true)
        potentialBarChaos.setProgress(Float(cosmicAlignment.level(.chaos, .potential)), animated: true)
        potentialBarAether.setProgress(Float(cosmicAlignment.level(.poly, .potential)), animated: true)
        
        
        
    }
    
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
        }
        return tableView.rowHeight
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
