//
//  SpectrographSettingsViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/12/23.
//

import UIKit

class SpectrographSettingsViewController: UIViewController {
    
    static func create() -> SpectrographSettingsViewController? {
        guard let viewController = UIStoryboard(name: "SpectrographSettings", bundle: nil).instantiateViewController(withIdentifier: "SpectrographSettingsViewController") as? SpectrographSettingsViewController else {
            return nil
        }
        return viewController
    }
    
    // Present the AboutPageViewController from a view controller
    static func present(from parentViewController: UIViewController? = nil) {
        guard let viewController = create() else {return}
        if let presentingViewController = parentViewController ?? UIApplication.shared.keyWindow?.rootViewController {
            presentingViewController.present(viewController, animated: true, completion: nil)
        }
    }
}
