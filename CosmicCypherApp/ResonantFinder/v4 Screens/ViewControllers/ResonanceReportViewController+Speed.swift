//
//  ResonanceReportViewController+Speed.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/15/23.
//

import UIKit

extension ResonanceReportViewController {
    
    // Setup Buttons
    func setupSpeedButton() {
        // drop down for Chart Data Mode Select
        let menu = UIMenu(children: [
            UIAction(title: "Speed: Seconds", handler:setSpeedToSeconds),
            UIAction(title: "Speed: Minutes", handler:setSpeedToMinutes),
            UIAction(title: "Speed: Hours", handler:setSpeedToHours),
            UIAction(title: "Speed: Days", handler:setSpeedToDays),
            UIAction(title: "Speed: Weeks", handler:setSpeedToWeeks),
            UIAction(title: "Speed: Months", handler:setSpeedToMonths),
            UIAction(title: "Speed: Years", handler:setSpeedToYears)])
        speedButton.menu = menu
    }
    
    // MARK: Speed Functions
    // Seconds
    func setSpeedToSeconds(action: UIAction) { setSpeedToSeconds() }
    func setSpeedToSeconds() {
        StarChart.Core.playbackController.set(speed: .seconds)
    }
    
    // Minutes
    func setSpeedToMinutes(action: UIAction) { setSpeedToMinutes() }
    func setSpeedToMinutes() {
        StarChart.Core.playbackController.set(speed: .minutes)
    }
    
    // Hours
    func setSpeedToHours(action: UIAction) { setSpeedToHours() }
    func setSpeedToHours() {
        StarChart.Core.playbackController.set(speed: .hours)
    }
    // Seconds
    func setSpeedToDays(action: UIAction) { setSpeedToDays() }
    func setSpeedToDays() {
        StarChart.Core.playbackController.set(speed: .days)
    }
    
    // Seconds
    func setSpeedToWeeks(action: UIAction) { setSpeedToWeeks() }
    func setSpeedToWeeks() {
        StarChart.Core.playbackController.set(speed: .weeks)
    }
    
    // Seconds
    func setSpeedToMonths(action: UIAction) { setSpeedToMonths() }
    func setSpeedToMonths() {
        StarChart.Core.playbackController.set(speed: .months)
    }
    
    // Seconds
    func setSpeedToYears(action: UIAction) { setSpeedToYears() }
    func setSpeedToYears() {
        StarChart.Core.playbackController.set(speed: .years)
    }
}
