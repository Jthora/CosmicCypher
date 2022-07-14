//
//  UIViewController+Extension.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/13/22.
//

import Foundation
import UIKit
extension UIViewController {
    
    var rootViewController:UIViewController {
        return parent?.rootViewController ?? parent ?? self
    }
    
    func dismissViewControllers(animated:Bool = true, completion: (()->Void)? = nil) {
        guard let vc = self.presentingViewController else {
            print("ERROR: cannot Dismiss, No Presented ViewController")
            return
        }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: animated, completion: completion)
        }
    }
    
    func dismissToRoot(animated:Bool = true, completion: (()->Void)? = nil) {
        rootViewController.dismissViewControllers(animated: animated, completion: completion)
    }
    
    func dismissAllViewControllers(animated:Bool = true, completion: (()->Void)? = nil) {
        self.view.window!.rootViewController?.dismiss(animated: animated, completion: completion)
    }
}
