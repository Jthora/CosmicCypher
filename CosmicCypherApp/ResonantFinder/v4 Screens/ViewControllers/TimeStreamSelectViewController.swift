//
//  TimeStreamSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/29/22.
//

import UIKit

class TimeStreamSelectViewController: UIViewController {
    
    // Present the TimeStreamInterfaceViewController from a view controller
    static func present(from parentViewController: UIViewController? = nil) {
        guard let vc = UIStoryboard(name: "TimeStreamSelect", bundle: nil).instantiateViewController(withIdentifier: "TimeStreamSelectViewController") as? TimeStreamSelectViewController else {
            return
        }
        if let presentingViewController = parentViewController ?? UIApplication.shared.keyWindow?.rootViewController {
            presentingViewController.present(vc, animated: true, completion: nil)
        }
    }
}
