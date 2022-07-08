//
//  OffgridGeoLocationSelectViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/29/22.
//

import UIKit

class OffgridGeoLocationSelectViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "StarChartSelect", bundle: nil).instantiateViewController(withIdentifier: "OffgridGeoLocationSelectViewController") as? OffgridGeoLocationSelectViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
}
