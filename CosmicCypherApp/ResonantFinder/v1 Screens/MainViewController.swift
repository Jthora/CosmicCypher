//
//  MainViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/8/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func editBirthdayButtonTap(_ sender: Any) {
        //BirthdaySelectViewController.presentModally(over: self)
    }
    
    @IBAction func resetSearchButtonTap(_ sender: Any) {
    }
    
    @IBAction func historyButtonTap(_ sender: Any) {
        ReportHistoryViewController.presentModally(over: self)
    }
    
    // MARK: Delegate - Results TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ResonanceReportViewController.presentModally(over: self)
    }
    
    // MARK: DataSource - Results TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell") as? ResultTableViewCell ?? UITableViewCell()
    }
    
}
