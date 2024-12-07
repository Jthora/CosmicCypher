//
//  GeoLocationSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/29/22.
//

import UIKit

class GeoLocationSelectViewController: UIViewController {
    
    var onDismiss: (()->())? = nil
    var originViewController:UIViewController? = nil
    
    static func presentModally(over presentingViewController: UIViewController, originViewController: UIViewController?, onDismiss: (()->())? = nil) {
        guard let vc:GeoLocationSelectViewController = UIStoryboard(name: "GeoLocationSelect", bundle: nil).instantiateViewController(withIdentifier: "GeoLocationSelectViewController") as? GeoLocationSelectViewController else {
            return
        }
        vc.onDismiss = onDismiss
        vc.originViewController = originViewController
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onDismiss?()
    }
}



