//
//  TimeStreamInterfaceViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/18/23.
//

import SwiftUI
import UIKit

class TimeStreamInterfaceViewController: UIViewController {
    
    //MARK: Storyboard IBOutlets
    // Playback Buttons
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var skipBackwardButton: UIButton!
    @IBOutlet weak var playForwardButton: UIButton!
    @IBOutlet weak var playBackwardButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var fastBackwardButton: UIButton!
    
    // Feedback
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // Start and End Date Labels
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    // Spectrograph Buttons
    @IBOutlet weak var spectrographSettingsButton: UIButton!
    @IBOutlet weak var spectrographPresetsButton: UIButton!
    @IBOutlet weak var spectrographExportButton: UIButton!
    
    // View Switch (Spectrograph to Chart)
    @IBOutlet weak var viewSwitchControl: UISegmentedControl!
    
    // Chart Mode Select Button
    @IBOutlet weak var chartModeSelectPopUpButton: UIButton!
    @IBOutlet weak var chartModeSelectMenu: UIMenu!
    
    
    // Charts Container View
    @IBOutlet weak var chartSuperView: UIView!
    
    // TimeStream Spectrogram
    @IBOutlet weak var timeStreamSpectrogramView: TimeStreamSpectrogramView!
    
    
    // MARK: Properties
    
    var lineChartView: TimeStream.Chart?
    var timeStreamComposite:TimeStream.Composite?
    
    // StarChart RealTime Playback Controller
    lazy var playbackController = {
        var controller = StarChartRealTimePlaybackController()
        controller.date = StarChart.Core.current.date
        controller.mode = .pause
        return controller
    }()
    
    // MARK: Static
    // Global Instance
    static var global:TimeStreamInterfaceViewController? = {
        guard let viewController = UIStoryboard(name: "TimeStreamInterface", bundle: nil).instantiateViewController(withIdentifier: "TimeStreamInterfaceViewController") as? TimeStreamInterfaceViewController else {
            return nil
        }
        return viewController
    }()
    
    // Present the TimeStreamInterfaceViewController from a view controller
    static func present(from parentViewController: UIViewController? = nil) {
        guard let viewController = global else {return}
        if let presentingViewController = parentViewController ?? UIApplication.shared.keyWindow?.rootViewController {
            presentingViewController.present(viewController, animated: true, completion: nil)
        }
    }
    
    // Present the TimeStreamInterfaceViewController within a container view
    static func present(in containerView: UIView) {
        guard let viewController = global else {return}
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
    }
    
    // MARK: ViewController LifeCycle
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeStream.Core.add(reactive: self)
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        TimeStream.Core.remove(reactive: self)
    }

    // MARK: Setup
    // Setup
    private func setup() {
        setupViews()
        setupLabels()
        setupButtons()
        setupSpectrogram()
        setupCharts()
    }
    
    func setupViews() {
        switch viewSwitchControl.selectedSegmentIndex {
        case 0: // Chart - line chart
            chartSuperView.isHidden = false
            chartModeSelectPopUpButton.isHidden = false
            
            timeStreamSpectrogramView.isHidden = true
            spectrographSettingsButton.isHidden = true
            spectrographPresetsButton.isHidden = true
            spectrographExportButton.isHidden = true
        case 1: // Graph - spectrogram
            chartSuperView.isHidden = true
            chartModeSelectPopUpButton.isHidden = true
            
            timeStreamSpectrogramView.isHidden = false
            spectrographSettingsButton.isHidden = false
            spectrographPresetsButton.isHidden = false
            spectrographExportButton.isHidden = false
        default: ()
        }
    }
    
    func setupLabels() {
        guard let composite = TimeStream.Core.currentComposites.first else {
            startDateLabel.text = ""
            endDateLabel.text = ""
            statusLabel.text = ""
            return
        }
        startDateLabel.text = composite.startDate?.formatted() ?? "Start Date"
        endDateLabel.text = composite.endDate?.formatted() ?? "End Date"
        statusLabel.text = ""
    }
    
    // Setup Buttons
    func setupButtons() {
        // drop down for Chart Data Mode Select
        let menu = UIMenu(children: [
            UIAction(title: "Gravimetrics Chart", handler:showGravimetricsClosure),
            UIAction(title: "Exa/Deb Chart", handler:showExaDebClosure),
            UIAction(title: "Rise/Fall Chart", handler:showRiseFallClosure)])
        chartModeSelectPopUpButton.menu = menu
    }
    
    func setupSpectrogram() {
        timeStreamSpectrogramView.setup()
    }
    
    func setupCharts(_ composite:TimeStream.Composite? = nil) {
        // setup view
        print("Setup Charts (TimeStreamInterfaceViewController)")
        guard let configuration = composite?.configuration ?? self.timeStreamComposite?.configuration ?? TimeStream.Core.currentComposites.first?.configuration else {return}
        
        lineChartView?.removeFromSuperview()
        lineChartView = nil
        lineChartView = TimeStream.Chart(frame: self.chartSuperView.frame, configuration: configuration, onComplete: {
            print("Line Chart Data Loaded")
        })
        
        self.chartSuperView.addSubview(lineChartView!)
        lineChartView?.centerInSuperview()
        lineChartView?.width(to: self.chartSuperView)
        lineChartView?.height(to: self.chartSuperView)
    }
    
    // MARK: Show / Hide
    // Show
    func showRiseFallClosure(action: UIAction) {
        showRiseFallClosure()
    }
    
    func showRiseFallClosure() {
        self.chartSuperView.isHidden = false
        self.chartSuperView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.chartSuperView.alpha = 1
        }
        print("Show Rise/Fall")
    }
    
    func showExaDebClosure(action: UIAction) {
        showExaDebClosure()
    }
    func showExaDebClosure() {
        self.chartSuperView.isHidden = false
        self.chartSuperView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.chartSuperView.alpha = 1
        }
        print("Show Exa/Deb")
    }
    
    func showGravimetricsClosure(action: UIAction) {
        showGravimetricsClosure()
    }
    func showGravimetricsClosure() {
        self.chartSuperView.isHidden = false
        self.chartSuperView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.chartSuperView.alpha = 1
        }
        print("Show Gravimetrics")
    }
    
    func showHarmonicsClosure(action: UIAction) {
        showHarmonicsClosure()
    }
    func showHarmonicsClosure() {
        self.chartSuperView.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.chartSuperView.alpha = 0
        } completion: { _ in
            self.chartSuperView.alpha = 0
            self.chartSuperView.isHidden = true
        }

        print("Show Harmonics")
    }
    
    // MARK: Settings
    // Settings
    @IBAction func settingsButtonTap(_ sender: UIButton) {
        SpectrographSettingsViewController.present()
    }
    // Presets
    @IBAction func presetsButtonTap(_ sender: UIButton) {
        TimeStreamSelectViewController.present()
    }
    // Export
    @IBAction func exportButtonTap(_ sender: UIButton) {
        
    }
    
    // MARK: View Switch
    @IBAction func viewSwitchControlChanged(_ sender: UISegmentedControl) {
        setupViews()
    }
    
    // MARK: Playback Controls
    @IBAction func pauseButtonTouch(_ sender: UIButton) {
        playbackController.pause()
    }
    
    @IBAction func stepForwardButtonTouch(_ sender: UIButton) {
        playbackController.step(.forward)
    }
    
    @IBAction func stepBackwardTouch(_ sender: UIButton) {
        playbackController.step(.backward)
    }
    
    @IBAction func playForwardButtonTouch(_ sender: UIButton) {
        playbackController.play(.forward)
    }
    
    @IBAction func playBackwardButtonTouch(_ sender: UIButton) {
        playbackController.play(.backward)
    }
    
    @IBAction func fastForwardButtonTouch(_ sender: UIButton) {
        playbackController.fast(.forward)
    }
    
    @IBAction func fastBackwardButtonTouch(_ sender: UIButton) {
        playbackController.fast(.backward)
    }
    
    
    // MARK: Chart Mode Select
    @IBAction func chartModeSelectTouch(_ sender: UIButton) {
        //chartModeSelectMenu.selectedElements
    }
    
    
    
    
}

extension TimeStreamInterfaceViewController: TimeStreamCoreReactive {
    
    /// The TimeStream Core has performed an Action
    func timeStreamCore(didAction action: TimeStream.Core.Action) {
        /// Async Thread
        DispatchQueue.main.async {
            // Handle Action
            switch action {
            case .onLoadTimeStream(loadTimeStreamAction: let loadTimeStreamAction):
                switch loadTimeStreamAction {
                /// Report on progress of loading StarChart data for the timestream
                case .progress(uuid: _, completion: let completion):
                    
                    // Progress Bar
                    self.progressView.setProgress(Float(completion), animated: true)
                    
                    // Set Activity Indicator
                    self.activityIndicatorView.isHidden = false
                    break
                    
                /// StarCharts all calculated and timestream data is fully loaded.
                case .complete(uuid: let uuid, composite: let composite):
                    
                    // Set Composite
                    self.timeStreamComposite = composite
                    
                    // Status Label
                    self.statusLabel.isHidden = true
                    self.statusLabel.text = ""
                    
                    // Date Labels
                    self.startDateLabel.text = composite.configuration.startDate?.formatted() ?? "Start Date"
                    self.endDateLabel.text = composite.configuration.endDate?.formatted() ?? "End Date"
                    
                    // Set Progress Bar
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0, animated: false)
                    
                    // Set Activity Indicator
                    self.activityIndicatorView.isHidden = true
                    
                    self.setupCharts(composite)
                    
                /// Start calculating StarCharts until all the starchart data for the timestream is fully loaded.
                case .start(uuid: let uuid, name: let name, configuration: let configuration):
                    
                    // Status Label
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Scrying..."
                    
                    // Date Labels
                    self.startDateLabel.text = configuration.startDate?.formatted() ?? "Start Date"
                    self.endDateLabel.text = configuration.endDate?.formatted() ?? "End Date"
                    
                    // Progress Bar
                    self.progressView.isHidden = false
                    self.progressView.setProgress(0, animated: false)
                    
                    // Set Activity Indicator
                    self.activityIndicatorView.isHidden = false
                    
                }
            case .update(updateAction: let updateAction):
                switch updateAction {
                case .currentComposite(composite: let composite):
                    
                    // Set Composite
                    self.timeStreamComposite = composite
                    
                    // Status Label
                    self.statusLabel.isHidden = true
                    
                    // Progress Bar
                    self.progressView.isHidden = true
                    
                    // Chart
                    self.setupCharts(composite)
                default: ()
                }
            }
        }
    }
}
