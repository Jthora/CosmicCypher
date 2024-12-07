//
//  StarChartRealTimePlaybackController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/20/23.
//

import Foundation

protocol StarChartRealTimePlaybackControllerDelegate: AnyObject {
    func didStep(_ direction:StarChartRealTimePlaybackController.DirectionSetting)
    func didSet(mode:StarChartRealTimePlaybackController.PlaybackMode)
}


class StarChartRealTimePlaybackController {
    
    let defaultPlaybackSampleRate:TimeInterval = 0.2
    var speed:TimeInterval = 1
    let defaultMode:PlaybackMode = .pause
    var mode:PlaybackMode = .pause {
        didSet {
            self.didSet(mode: mode)
        }
    }
    
    var sampleStep:SampleStep = .hours
    var sampleRate:SampleRate = .onePerSecond
    
    var date:Date = StarChart.Core.current.date
    
    var playbackTimer: Timer?
    
    // MARK: Delegate
    // Delegates
    private var _delegates: [StarChartRealTimePlaybackControllerDelegate] = []
    // Add a delegate
    func addDelegate(_ delegate: StarChartRealTimePlaybackControllerDelegate) {
        if !_delegates.contains(where: { $0 === delegate }) {
            _delegates.append(delegate)
        }
    }
    // Remove a delegate
    func removeDelegate(_ delegate: StarChartRealTimePlaybackControllerDelegate) {
        _delegates = _delegates.filter { $0 !== delegate }
    }
    // Function to call delegate methods
    func didStep(_ direction: StarChartRealTimePlaybackController.DirectionSetting) {
        for delegate in _delegates {
            delegate.didStep(direction)
        }
    }

    func didSet(mode: StarChartRealTimePlaybackController.PlaybackMode) {
        for delegate in _delegates {
            delegate.didSet(mode: mode)
        }
    }
    
    // MARK: Enums
    // Speed Command
    enum SpeedCommand {
        case pause
        case step(_ direction:DirectionSetting)
        case play(_ direction:DirectionSetting)
        case fast(_ direction:DirectionSetting)
    }
    
    // Direction Setting
    enum DirectionSetting {
        case forward
        case backward
        
        var text:String {
            switch self {
            case .forward: return "Forward"
            case .backward: return "Backward"
            }
        }
    }
    
    // Playback Mode
    enum PlaybackMode {
        case pause
        case play(_ direction:DirectionSetting)
        case fast(_ direction:DirectionSetting)
        
        var text:String {
            switch self {
            case .pause: return "Pause"
            case .play(let direction): return "Play \(direction.text)"
            case .fast(let direction): return "Fast \(direction.text)"
            }
        }
    }
    
    enum SampleStep:Int, CaseIterable {
        case seconds
        case minutes
        case hours
        case days
        case weeks
        case months
        case years
        
        var timeInterval:TimeInterval {
            switch self {
            case .seconds: return 1
            case .minutes: return 60
            case .hours: return 3600
            case .days: return 86400 // 1 day = 24 hours * 60 minutes * 60 seconds
            case .weeks: return 604800 // 1 week = 7 days * 24 hours * 60 minutes * 60 seconds
            case .months: return 2628000 // An approximate value for 1 month (30.44 days on average) * 24 hours * 60 minutes * 60 seconds
            case .years: return 31536000 // 1 year = 365 days * 24 hours * 60 minutes * 60 seconds
            }
        }
    }
    
    enum SampleRate:Int, CaseIterable {
        case onePerSecond
        case twoPerSecond
        case fivePerSecond
        case tenPerSecond
        
        var multiplyer:Double {
            switch self {
            case .onePerSecond: return 1
            case .twoPerSecond: return 0.5
            case .fivePerSecond: return 0.2
            case .tenPerSecond: return 0.1
            }
        }
    }
    
    enum ScrubberState {
        case set
        case moving
    }
    
    // MARK: Commands
    func command(_ command:SpeedCommand) {
        
        // Set Date (if changed outside)
        date = StarChart.Core.current.date
        
        // Perform Command
        switch command {
        case .pause:
            mode = .pause
        case .step(let direction):
            mode = .pause
            step(direction)
        case .play(let direction):
            mode = .play(direction)
        case .fast(let direction):
            mode = .fast(direction)
        }
        
        // Handle Playback
        handlePlayback()
    }
    
    func set(speed:SampleStep) {
        sampleStep = speed
    }
    
    
    // MARK: Playback
    // Pause
    func pause() {
        command(.pause)
    }
    
    // Step
    func step(_ direction:DirectionSetting) {
        updateStarChartDate(direction: direction, fast: false)
    }
    
    // Play
    func play(_ direction:DirectionSetting) {
        command(.play(direction))
    }
    
    // Fast
    func fast(_ direction:DirectionSetting) {
        command(.fast(direction))
    }
    
    // Start playback with the current mode and speed
    func startPlayback() {
        guard playbackTimer == nil else { return }
        
        playbackTimer = Timer.scheduledTimer(withTimeInterval: defaultPlaybackSampleRate, repeats: true) { [weak self] _ in
            self?.handlePlayback()
        }
    }
    
    // Stop playback
    func stopPlayback() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    // Handle playback logic
    private func handlePlayback() {
        switch mode {
        case .pause:
            stopPlayback()
        case .play(.forward):
            startPlayback()
            updateStarChartDate(direction: .forward, fast: false)
        case .play(.backward):
            startPlayback()
            updateStarChartDate(direction: .backward, fast: false)
        case .fast(.forward):
            startPlayback()
            updateStarChartDate(direction: .forward, fast: true)
        case .fast(.backward):
            startPlayback()
            updateStarChartDate(direction: .backward, fast: true)
        }
    }
    
    // Update StarChart Date
    private func updateStarChartDate(direction: DirectionSetting, fast: Bool) {
        
        let playbackRate = fast ? 2.0 : 1.0
        let timeInterval = direction == .forward ? (defaultPlaybackSampleRate * playbackRate) : (-defaultPlaybackSampleRate * playbackRate)
        
        let timeStepInterval = sampleStep.timeInterval * timeInterval
        
        let nextDate = date.addingTimeInterval(timeStepInterval)
        self.date = nextDate
        
        // Check Current TimeStream for StarChart
        let currentStarChart = StarChart.Core.current
        
        // Check StarChart Registry
        /// Create New StarChart
        do {
            let nextStarChart = try StarChartRegistry.main.getStarChart(date: nextDate,
                                                                        geographicCoordinates: currentStarChart.coordinates)
            
            // Add New StarChart to TimeStream
            StarChart.Core.current = nextStarChart
            
            self.didStep(direction)
        } catch {
            print("❌ StarChartRegistry getStarChart")
        }
    }

}
