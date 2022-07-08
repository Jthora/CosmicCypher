//
//  EditTimeStreamViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/2/22.
//

import Foundation
import UIKit

class EditTimeStreamViewController: UIViewController {
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "v4", bundle: nil).instantiateViewController(withIdentifier: "EditTimeStreamViewController") as? EditTimeStreamViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            //vc.delegate = delegate
        }
        
    }
}
