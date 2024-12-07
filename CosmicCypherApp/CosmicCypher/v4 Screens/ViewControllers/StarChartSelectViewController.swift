//
//  StarChartSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/29/22.
//

import UIKit

class StarChartSelectViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "StarChartSelect", bundle: nil).instantiateViewController(withIdentifier: "StarChartSelectViewController") as? StarChartSelectViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    @IBAction func rightNowButtonTouch(_ sender: UIButton) {
        
        //ResonanceReportViewController.current?.isLive = true
        
        StarChart.Core.current = StarChart(date: Date(), coordinates: StarChart.Core.current.coordinates)
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
        
        if let p = self.parent {
            p.dismiss(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tomorrowButtonTouch(_ sender: UIButton) {
        guard let date = Date.beginningOf(.tomorrow) else {
            print("FAILED: tomorrowButtonTouch")
            return
        }
        
        StarChart.Core.current = StarChart(date: date, coordinates: StarChart.Core.current.coordinates)
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
        
        if let p = self.parent {
            p.dismiss(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func twoDaysAheadButtonTouch(_ sender: UIButton) {
        guard let date = Date.beginningOf(.dayAfterToday(2)) else {
            print("FAILED: twoDaysAheadButtonTouch")
            return
        }
        
        StarChart.Core.current = StarChart(date: date, coordinates: StarChart.Core.current.coordinates)
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
        
        if let p = self.parent {
            p.dismiss(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func threeDaysAheadButtonTouch(_ sender: UIButton) {
        guard let date = Date.beginningOf(.dayAfterToday(3)) else {
            print("FAILED: threeDaysAheadButtonTouch")
            return
        }
        
        StarChart.Core.current = StarChart(date: date, coordinates: StarChart.Core.current.coordinates)
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
        
        if let p = self.parent {
            p.dismiss(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
