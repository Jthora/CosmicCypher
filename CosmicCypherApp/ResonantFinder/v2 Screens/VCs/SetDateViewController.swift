//
//  SetDateViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/13/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit

class SetDateViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "DateSelect", bundle: nil).instantiateViewController(withIdentifier: "SetDateViewController") as? SetDateViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func liveFeedButtonTap(_ sender: UIButton) {
        
        ResonanceReportViewController.current?.isLive = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func specificDateButtonTap(_ sender: Any) {
        
        ResonanceReportViewController.current?.isLive = false
        
    }
}
