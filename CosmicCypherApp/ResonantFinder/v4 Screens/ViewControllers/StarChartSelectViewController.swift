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
        
        ResonanceReportViewController.current?.isLive = true
        
        StarChart.Core.current = StarChart(date: Date(), coordinates: StarChart.Core.current.coordinates)
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
        
        self.dismiss(animated: true, completion: nil)
    }
}
