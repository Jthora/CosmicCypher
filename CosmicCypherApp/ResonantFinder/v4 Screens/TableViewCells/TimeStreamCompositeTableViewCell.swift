//
//  TimeStreamCompositeTableViewCell.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 12/11/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import SpriteKit
import Charts





class TimeStreamCompositeTableViewCell: UITableViewCell {

    @IBOutlet weak var spriteKitView: SKView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var calculatingLabel: UILabel!
    
    @IBOutlet weak var chartSuperView: UIView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var chartViewMessageLabel: UILabel!
    @IBOutlet weak var displayOptionButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var reloadButton: UIButton!
    
    
    @IBOutlet weak var exportButton: UIButton!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var lineChartView: TimeStream.Chart?
    
    lazy var scene:SKScene = generateSpriteKitScene()
    
    var _uuid:UUID? = nil
    var uuid:UUID? {
        set {
            _uuid = newValue
        }
        get {
            return timeStreamComposite?.uuid ?? _uuid
        }
    }
    var uuidString:String? {
        if timeStreamComposite?.uuid != nil {
            return nil
        }
        return _uuid?.uuidString
    }
    
    var timeStreamComposite:TimeStream.Composite?
    var sprites:[TimeStream.Composite.SpriteNode] = []
    
    var currentPoint:TimeStream.Point? {
        return self.compositeSprite?.getTimeStreamPoint()
    }
    
    var compositeSprite:TimeStream.Composite.SpriteNode? {
        return self.sprites.first
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupCosmicEventSpriteNodes()
        
        spriteKitView.presentScene(scene)
        
        // TimeStreamCoreReactive
        /// (it's like a delegate observable)
        TimeStream.Core.add(reactive: self)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    func setup(name: String? = nil, configuration: TimeStream.Configuration? = nil) {
        
        // Clear
        scene.removeAllChildren()
        sprites.removeAll()
        scene.shouldEnableEffects = true
        
        // Initialization code
        spriteKitView.borderWidth = 1
        spriteKitView.borderColor = .black
        
        setupLabels(name: name, configuration: configuration)
        
        setupButtons()
        setupCharts()
        setChartData(.gravimetrics)
        
        setupTimeStreamCompositeSpriteNode()
        
        setupGestureRecognizers()
        
    }
    
    func setupButtons() {
        displayOptionButton.menu = UIMenu(children: [
            UIAction(title: "Harmonics Spectrograph", state: .on, handler:showHarmonicsClosure),
            UIAction(title: "Global Net Energy [Gravimetrics]", handler:showGravimetricsClosure),
            UIAction(title: "Exa/Deb Chart", handler:showExaDebClosure),
            UIAction(title: "Rise/Fall Chart", handler:showRiseFallClosure)])
    }
    
    func setupChartGraph() {
        
    }
    
    func setupGestureRecognizers() {
        
        // Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        spriteKitView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        // 2-Finger Drag Gesture
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragGesture(_:)))
        dragGesture.minimumNumberOfTouches = 2
        dragGesture.maximumNumberOfTouches = 2
        spriteKitView.addGestureRecognizer(dragGesture)
        dragGesture.delegate = self
        
        // 2 Finger Zoom Gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        spriteKitView.addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = self
    }
    
    // MARK: Move TimeStream Focus Key
    private var _isPanning:Bool = false
    private var _canDrag:Bool? = nil
    @objc func panGesture(_ recognizer: UITapGestureRecognizer)  {
        //print("pan")
        
        guard let compositeSprite = compositeSprite else {
            print("Pan: cancel - waiting for composite sprite")
            return
        }
        
        // calculate x y position
        let panPosition = recognizer.location(in: self.spriteKitView)
        let normalizedX = panPosition.x / self.spriteKitView.frame.width
        let normalizedY = panPosition.y / self.spriteKitView.frame.height
        let x = (normalizedX * scene.size.width) - (scene.size.width/2)
        let y = (normalizedY * scene.size.height) - (scene.size.height/2)
        
        // First Time Check
        
        if _isPanning == false {
            if compositeSprite.scrubberCloseTo(x: x) {
                _canDrag = true
            } else {
                _canDrag = false
            }
        }
        
        switch recognizer.state {
        case .began:
            _isPanning = true
            if _canDrag == true {
                compositeSprite.setScrubber(x: x)
            }
            
        case .changed:
            _isPanning = true
            if _canDrag == true {
                compositeSprite.setScrubber(x: x)
            }
        case .ended:
            _isPanning = false
            _canDrag = nil
        case .cancelled, .failed:
            _isPanning = false
            _canDrag = nil
        case .possible:
            break
        @unknown default: ()
        }
    }
    
    // MARK: Scroll TimeStream
    @objc func dragGesture(_ recognizer: UITapGestureRecognizer)  {
        print("drag")
        let dragPosition = recognizer.location(in: self.spriteKitView)
        let normalizedPosition = CGPoint(x: dragPosition.x / self.spriteKitView.frame.width, y: dragPosition.y / self.spriteKitView.frame.height)
        let scenePosition = CGPoint(x: normalizedPosition.x * self.scene.size.width, y: normalizedPosition.y * self.scene.size.height)
        let sprite:TimeStream.Composite.SpriteNode = self.sprites.first!
        
        
        //let panRatioX = panPosition.x / self.spriteKitView.frame.width
        
        
        //sprite.setScrubber(x: (panRatioX * scene.size.width) - (scene.size.width/2))
    }
    
    // MARK: Scry Zoom TimeStream
    @objc func pinchGesture(_ recognizer: UITapGestureRecognizer)  {
        print("zoom")
        let panPosition = recognizer.location(in: self.spriteKitView)
        
        let panRatioX = panPosition.x / self.spriteKitView.frame.width
        
        let sprite:TimeStream.Composite.SpriteNode = self.sprites.first!
        //sprite.setScrubber(x: (panRatioX * scene.size.width) - (scene.size.width/2))
    }
    
    func update(name: String? = nil, configuration: TimeStream.Configuration? = nil) {
        setup(name: name, configuration: configuration)
        setChartData(.gravimetrics)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLabels(name: String? = nil, configuration:TimeStream.Configuration? = nil) {
        DispatchQueue.main.async {
            let name: String = name ?? configuration?.timeStreams.first?.title ?? self.timeStreamComposite?.name ?? self.uuidString ?? "Timestream"
            let startDate: String = configuration?.startDate?.formatted(date: .numeric, time: .omitted) ?? self.timeStreamComposite?.startDate?.formatted(date: .numeric, time: .omitted) ?? "startDate"
            let endDate: String = configuration?.endDate?.formatted(date: .numeric, time: .omitted) ?? self.timeStreamComposite?.endDate?.formatted(date: .numeric, time: .omitted) ?? "endDate"
            
            self.nameLabel.text = name ?? "???"
            
            self.dateLabel.text = "\(startDate) - \(endDate)"
        }
    }
    
    func setupSpriteKitView() {
        DispatchQueue.main.async {
            self.spriteKitView.presentScene(self.generateSpriteKitScene())
        }
    }
    
    func setupCosmicEventSpriteNodes() {
        let starChart = StarChart(date: Date())
        let aspect = starChart.aspects.first!
        let testSprite = SpriteNodeCosmicEvent(aspect: aspect, primaryBodyLongitude: 0, secondaryBodyLongitude: 0, size: scene.size)!
        testSprite.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        scene.addChild(testSprite)
    }
    
    func setupTimeStreamCompositeSpriteNode() {
        DispatchQueue.main.async {
            // Confirm Composite Exists
            guard let timeStreamComposite = self.timeStreamComposite else {
                /// show loading
                self.progressBar.isHidden = false
                self.calculatingLabel.isHidden = false
                self.progressBar.setProgress(0, animated: false)
                return
            }
            /// hide loading
            self.progressBar.isHidden = true
            self.calculatingLabel.isHidden = true
            self.progressBar.setProgress(1, animated: false)
            
            
            let timeStreamCompositeSpriteNode = TimeStream.Composite.SpriteNode(timeStreamComposite: timeStreamComposite, size: self.scene.size)
            timeStreamCompositeSpriteNode.center(.scene(self.scene))
            
            // Add to Scene
            self.sprites.append(timeStreamCompositeSpriteNode)
            self.scene.addChild(timeStreamCompositeSpriteNode)
        }
    }
    
    func generateSpriteKitScene() -> SKScene {
        return SKScene(size: self.spriteKitView.frame.size)
    }
    
    
    func setupCharts() {
        // setup view
        guard let configuration = self.timeStreamComposite?.configuration else {return}
        lineChartView = TimeStream.Chart(frame: self.chartView.frame, configuration: configuration)
        
        self.chartView.addSubview(lineChartView!)
        lineChartView?.centerInSuperview()
        lineChartView?.width(to: self.chartView)
        lineChartView?.height(to: self.chartView)
    }
    
    func setChartData(_ chartMode:TimeStream.Chart.ChartMode) {
        DispatchQueue.main.async {
            self.chartViewMessageLabel.isHidden = false
        }
        
        lineChartView?.setupChartData(chartMode: chartMode, onComplete: {
            DispatchQueue.main.async {
                self.chartViewMessageLabel.isHidden = true
            }
        })
    }
    
    
    func showRiseFallClosure(action: UIAction) {
        self.chartSuperView.isHidden = false
        self.chartSuperView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.chartSuperView.alpha = 1
        }
        print("Show Rise/Fall")
    }
    
    func showExaDebClosure(action: UIAction) {
        self.chartSuperView.isHidden = false
        self.chartSuperView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.chartSuperView.alpha = 1
        }
        print("Show Exa/Deb")
    }
    
    func showGravimetricsClosure(action: UIAction) {
        self.chartSuperView.isHidden = false
        self.chartSuperView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.chartSuperView.alpha = 1
        }
        print("Show Gravimetrics")
    }
    
    func showHarmonicsClosure(action: UIAction) {
        self.chartSuperView.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.chartSuperView.alpha = 0
        } completion: { _ in
            self.chartSuperView.alpha = 0
            self.chartSuperView.isHidden = true
        }

        print("Show Harmonics")
    }
}

extension TimeStreamCompositeTableViewCell: TimeStreamCoreReactive {
    func timeStreamCore(didAction action: TimeStream.Core.Action) {
        DispatchQueue.main.async {
            switch action {
            case .onLoadTimeStream(loadTimeStreamAction: let loadTimeStreamAction):
                switch loadTimeStreamAction {
                case .progress(uuid: let uuid, completion: let completion):
                    print("onLoadTimeStream .progress")
                    guard uuid == self.uuid else { return }
                    self.progressBar.isHidden = false
                    self.calculatingLabel.isHidden = false
                    
                    // Animate Completion Bar
                    self.progressBar.setProgress(Float(completion), animated: true)
                    break
                case .complete(uuid: let uuid, composite: let composite):
                    print("onLoadTimeStream .complete")
                    // required UUID
                    guard uuid == self.uuid else { return }
                    self.timeStreamComposite = composite
                    self.update()
                    
                    // Set Completion Bar
                    self.calculatingLabel.isHidden = true
                    self.progressBar.isHidden = true
                    self.progressBar.setProgress(0, animated: false)
                    
                    // Prepare UI
                    self.update(name: composite.name, configuration: composite.configuration)
                case .start(uuid: let uuid, name: let name, configuration: let configuration):
                    print("onLoadTimeStream .start")
                    // required UUID
                    guard uuid == self.uuid else { return }
                    
                    // Animate Completion Bar
                    self.progressBar.isHidden = false
                    self.calculatingLabel.isHidden = false
                    self.progressBar.setProgress(0, animated: false)
                    
                    // Prepare UI
                    self.update(name: name, configuration: configuration)
                }
            case .update(updateAction: let updateAction):
                switch updateAction {
                case .composites(composites: _):
                    self.progressBar.isHidden = true
                    self.calculatingLabel.isHidden = true
                    self.update()
                case .currentComposite(composite: let composite):
                    // Prepare UI
                    self.update(name: composite.name, configuration: composite.configuration)
                }
            }
        }
    }
}
