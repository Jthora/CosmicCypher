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
    let defaultSpeed:PlaybackMode = .pause
    var mode:PlaybackMode = .pause
    
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
    
    enum ScrubberState {
        case set
        case moving
    }
    
    func command(_ command:SpeedCommand) {
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
    }
    
    
    // MARK: Playback
    
    func step(_ direction:DirectionSetting, by timeInterval:TimeInterval? = nil) {
        let timeInterval = timeInterval ?? defaultPlaybackSampleRate
        guard timeInterval != 0 else {return}
        print("step")
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
