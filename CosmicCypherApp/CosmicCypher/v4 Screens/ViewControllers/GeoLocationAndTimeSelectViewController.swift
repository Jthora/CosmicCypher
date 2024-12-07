//
//  GeoLocationAndTimeSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import UIKit

class GeoLocationAndTimeSelectViewController: UIViewController {
    
    var onDismiss: (()->())? = nil
    static func presentModally(over presentingViewController: UIViewController, onDismiss: (()->())? = nil) {
        guard let vc:GeoLocationAndTimeSelectViewController = UIStoryboard(name: "StarChartSelect", bundle: nil).instantiateViewController(withIdentifier: "GeoLocationAndTimeSelectViewController") as? GeoLocationAndTimeSelectViewController else {
            return
        }
        vc.onDismiss = onDismiss
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onDismiss?()
    }
}


