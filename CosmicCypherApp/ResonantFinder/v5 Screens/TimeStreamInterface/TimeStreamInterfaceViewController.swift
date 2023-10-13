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
    
    // TimeStream Labels
    @IBOutlet weak var timeStreamNameLabel: UILabel!
    @IBOutlet weak var timeStreamDateRangeLabel: UILabel!
    @IBOutlet weak var timeStreamGeoLocationLabel: UILabel!
    
    // Settings Button
    @IBOutlet weak var timeStreamSettingsButton: UIButton!
    
    // Graph Drop Down Selector Control
    @IBOutlet weak var timeStreamGraphControl: UIButton!
    
    // TimeStream Loading Progress
    @IBOutlet weak var timeStreamProgressBar: UIProgressView!
    
    // TimeStream Data Scrubber
    @IBOutlet weak var timeStreamHorizontalSlider: UISlider!
    
    // ImageMap View
    @IBOutlet weak var imageMapView: UIImageView!
    
    // Charts Container View
    @IBOutlet weak var chartSuperView: UIView!
    
    // TimeStream Spectrogram
    @IBOutlet weak var timeStreamSpectrogramView: TimeStreamSpectrogramView!
    
    // Console
    @IBOutlet weak var timeStreamConsoleTextView: UITextView!
    
    // MARK: Properties
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
        setup()
    }

    // MARK: Setup
    // Setup
    private func setup() {
        setupButtons()
        setupConsole()
        setupSpectrogram()
    }
    
    func setupLabels() {
        guard let composite = TimeStream.Core.currentComposites.first else {
            return
        }
        timeStreamNameLabel.text = "\(composite.name ?? "[TimeStream Name]")"
        timeStreamDateRangeLabel.text = "\(composite.startDate?.formatted(date: .numeric, time: .omitted) ?? "[Date]") to \(composite.endDate?.formatted(date: .numeric, time: .omitted) ?? "[Date]")"
        timeStreamGeoLocationLabel.text = "\(composite.configuration.timeStreams.first?.path.points.first?.coordinates.labelText ?? "[Geo Coordinates]")"
    }
    
    // Setup
    func setupConsole() {
        let consoleText = "TimeStream Console"
        timeStreamConsoleTextView.text = consoleText
    }
    
    // Setup Buttons
    func setupButtons() {
        timeStreamGraphControl.menu = UIMenu(children: [ // displayOptionButton.menu
            UIAction(title: "Harmonics Spectrograph", state: .on, handler:showHarmonicsClosure),
            UIAction(title: "Global Net Energy [Grav]", handler:showGravimetricsClosure),
            UIAction(title: "Exa/Deb Chart", handler:showExaDebClosure),
            UIAction(title: "Rise/Fall Chart", handler:showRiseFallClosure)])
    }
    
    func setupSpectrogram() {
        timeStreamSpectrogramView.setup()
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
    // Settings Button
    @IBAction func settingsButtonTap(_ sender: UIButton) {
        TimeStreamSelectViewController.present()
    }
    
    @IBAction func pauseButtonTouch(_ sender: UIButton) {
        playbackController.pause()
    }
    
    
    @IBAction func stepForwardButtonTouch(_ sender: UIButton) {
    }
    
    
    @IBAction func stepBackwardTouch(_ sender: UIButton) {
    }
    
    
    @IBAction func playForwardButtonTouch(_ sender: UIButton) {
    }
    
    
    @IBAction func playBackwardButtonTouch(_ sender: UIButton) {
    }
    
    
    @IBAction func fastForwardButtonTouch(_ sender: UIButton) {
    }
    
    
    @IBAction func fastBackwardButtonTouch(_ sender: UIButton) {
    }
    
    
    
    
    
    
}
