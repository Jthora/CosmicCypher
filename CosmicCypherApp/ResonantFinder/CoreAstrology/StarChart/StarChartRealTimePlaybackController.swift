//
//  StarChartRealTimePlaybackController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/20/23.
//

import Foundation

protocol StarChartRealTimePlaybackControllerDelegate {
    func didStep(_ direction:StarChartRealTimePlaybackController.DirectionSetting)
}


class StarChartRealTimePlaybackController {
    
    let defaultPlaybackSampleRate:TimeInterval = 1
    var speed:TimeInterval = 1
    let defaultMode:PlaybackMode = .pause
    var mode:PlaybackMode = .pause
    
    var sampleStep:SampleStep = .seconds
    var sampleRate:SampleRate = .onePerSecond
    
    var date:Date = Date()
    
    var playbackTimer: Timer?
    
    var delegate: StarChartRealTimePlaybackControllerDelegate? = nil
    
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
    }
    
    // Playback Mode
    enum PlaybackMode {
        case pause
        case play(_ direction:DirectionSetting)
        case fast(_ direction:DirectionSetting)
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
    
    func command(_ command:SpeedCommand) {
        switch command {
        case .pause:
            mode = .pause
        case .step(let direction):
            step(direction)
        case .play(let direction):
            mode = .play(direction)
        case .fast(let direction):
            mode = .fast(direction)
        }
        handlePlayback()
    }
    
    func set(speed:TimeInterval) {
        
    }
    
    
    // MARK: Playback
    // Pause
    func pause() {
        command(.pause)
    }
    
    // Step
    func step(_ direction:DirectionSetting, by timeInterval:TimeInterval? = nil) {
        let timeInterval = timeInterval ?? speed
        guard timeInterval != 0 else {return}
        command(.step(direction))
        print("step")
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
        case .play(.forward):
            updateStarChartDate(direction: .forward, fast: false)
        case .play(.backward):
            updateStarChartDate(direction: .backward, fast: false)
        case .fast(.forward):
            updateStarChartDate(direction: .forward, fast: true)
        case .fast(.backward):
            updateStarChartDate(direction: .backward, fast: true)
        default:
            break
        }
    }
    
    // Update StarChart Date
    private func updateStarChartDate(direction: DirectionSetting, fast: Bool) {
        
        let playbackRate = fast ? 2.0 : 1.0
        let timeInterval = direction == .forward ? (defaultPlaybackSampleRate * playbackRate) : (-defaultPlaybackSampleRate * playbackRate)
        
        let updatedDate = date.addingTimeInterval(timeInterval)
        
        // Check Current TimeStream for StarChart
        let currentStarChart = StarChart.Core.current
        
        // Check StarChart Registry
        /// Create New StarChart
        let newStarChart = StarChart(date: updatedDate)
        
        // Add New StarChart to TimeStream
        StarChart.Core.current = newStarChart
        
        self.delegate?.didStep(direction)
    }

}
