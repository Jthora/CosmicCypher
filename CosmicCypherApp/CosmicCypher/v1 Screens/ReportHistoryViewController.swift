//
//  ReportHistoryViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/8/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit

class ReportHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportHistoryViewController") as? ReportHistoryViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            // Presented
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ResonanceReportViewController.presentModally(over: self)
    }
    
    // MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ResultHistoryTableViewCell") as? ResultHistoryTableViewCell ?? UITableViewCell()
    }
}
