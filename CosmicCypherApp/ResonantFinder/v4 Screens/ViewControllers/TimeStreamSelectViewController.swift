//
//  TimeStreamSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/29/22.
//

import UIKit

class TimeStreamSelectViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "TimeStreamSelect", bundle: nil).instantiateViewController(withIdentifier: "TimeStreamSelectViewController") as? TimeStreamSelectViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
}
