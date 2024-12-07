//
//  ResonanceReportViewController+StarChartRealTimePlaybackControllerDelegate.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/15/23.
//

import Foundation


extension ResonanceReportViewController: StarChartRealTimePlaybackControllerDelegate {
    func didStep(_ direction: StarChartRealTimePlaybackController.DirectionSetting) {
        DispatchQueue.main.async {
            // TODO: Update ResonanceReport views based on new StarChart.Core.current data
            self.update()
        }
    }
    
    func didSet(mode: StarChartRealTimePlaybackController.PlaybackMode) {
        DispatchQueue.main.async {
            self.speedModeLabel.text = "Mode: \(mode.text)"
        }
    }
}
