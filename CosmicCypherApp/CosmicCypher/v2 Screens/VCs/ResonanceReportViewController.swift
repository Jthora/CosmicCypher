//
//  ResonanceReportViewController.swift
//  CosmicCypher
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
    
    // MARK: Present View
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
    
    // MARK: Bar Labels
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
    
    // MARK: Modality Indicators
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
    
    // Central UI Elements
    @IBOutlet weak var dateTimeCoordsLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var planetSelectButton: UIButton!
    @IBOutlet weak var aspectEventScannerButton: UIButton!
    
    @IBOutlet weak var speedModeLabel: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    
    // MARK: Bottom Sheet TimeStream Interface
    // TimeStream Interface (Bottom Controls
    @IBOutlet weak var timeStreamInterfaceContainerView: TimeStreamInterfaceContainerView!
    
    // MARK: Extra Buttons
    // Share Button
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    // MARK: Mode
    // Central UI Hide Mode
    var interfaceIsHidden:Bool = true
    
    // Old Update Timer
    var readingUpdateTimer:Timer? = nil
    
    // MARK: Cosmic Disk
    @IBOutlet weak var spriteKitView: SKView!
    var scene:SKScene = SKScene(size: CGSize(width: 512, height: 512))
    var cosmicDiskSprite:CosmicAlignmentSpriteNode = CosmicAlignmentSpriteNode() // Empty
    
    @IBOutlet weak var aspectsResultsTableView: UITableView!
    //@IBOutlet weak var timeStreamTableView: UITableView!
    
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
        //timeStreamTableView.delegate = self
        //timeStreamTableView.dataSource = self
        
        TimeStream.Core.add(reactive: self)
        StarChart.Core.add(reactive: self)
        
        startup()
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetEnergyLevels()
        ResonanceReportViewController.current = self
        StarChart.Core.playbackController.addDelegate(self)
        
        // Preset UI hidden state
        hideCentralUI()
    }
    
    // View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBarLabels()
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StarChart.Core.playbackController.removeDelegate(self)
    }
    
    // MARK: Startup
    func startup() {
        setup()
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
    var updateQueue:DispatchQueue = DispatchQueue(label: "updateQueue")
    
    // Update Operation Queue
    private let _updateOperationQueue: OperationQueue = {
        let op = OperationQueue()
        op.isSuspended = false
        return op
    } ()
    
    
    
    // MARK: StarChart
    func setStarChart(date:Date, coordinates:GeographicCoordinates? = nil) {
        StarChart.Core.current = StarChart(date: date, coordinates: coordinates)
    }
    
    func renderStarChart() {
        StarChart.Core.renderStarChart(size: scene.size)
    }
    
    // MARK: Buttons
    @IBAction func aspectEventScannerButtonTouch(_ sender: UIButton) {
        //TimeStreamSettingsViewController.presentModally(over: self)
        CelestialEventScanViewController.presentModally(over: self)
    }
    
    @IBAction func instructionsButtonTouch(_ sender: UIButton) {
        CosmicCypherInstructionsViewController.presentModally(over: self)
    }
    
    @IBAction func planetSelectButtonTouch(_ sender: UIButton) {
        PlanetNodesViewController.presentModally(over: self, selectionContext: .starChart)
    }
    
    @IBAction func settingsButtonTouch(_ sender: UIButton) {
        SettingsViewController.presentModally(over: self)
        //StarChartSelectViewController.presentModally(over: self)
    }
    
    @IBAction func barsTouched(_ sender: UIButton) {
        ElementalReadingViewController.presentModally(over: self)
    }
    
    // MARK: Speed Controls
    @IBAction func speedButtonTouch(_ sender: UIButton) {
        
    }
    
    // MARK: Actions - Extra Buttons
    // Share Button
    @IBAction func shareButtonTouch(_ sender: UIButton) {
        DispatchQueue.main.async {
            /// Sharing Message.
            let message = "Cosmic Cypher App"
            let link = NSURL(string: "https://cosmiccypher.app/")
            /// Screenshot:
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
            self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            /// Set the link, message, image to share.
            if let link = link, let img = img {
                let objectsToShare = [message, link, img] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                /// Check if the device is an iPad and set the sourceView and sourceRect properties accordingly.
                if let popoverPresentationController = activityVC.popoverPresentationController {
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = sender.frame
                }

                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            } else {
                print("Error: Set the link, message, image to share not working...")
            }
        }
    }
    
    // About Button
    @IBAction func aboutButtonTouch(_ sender: UIButton) {
        /// Present About Page
        AboutPageViewController.present(from: self)
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
    
}
