//
//  AboutPageViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/19/23.
//

import UIKit

class AboutPageViewController: UIViewController {
    
    static func create() -> AboutPageViewController? {
        guard let viewController = UIStoryboard(name: "AboutPage", bundle: nil).instantiateViewController(withIdentifier: "AboutPageViewController") as? AboutPageViewController else {
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
