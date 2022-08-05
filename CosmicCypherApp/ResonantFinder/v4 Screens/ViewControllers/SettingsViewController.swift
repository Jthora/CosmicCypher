//
//  SettingsViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/23/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
}
