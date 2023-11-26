//
//  TimeMapTableViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation

import UIKit

class TimeMapTableViewController: UITableViewController {
    
    // Define your data structure to hold time-related information
    struct TimeInfo {
        let time: String
        let event: String
        // Add more properties as needed
    }
    
    // Sample data
    var timeInfoArray: [TimeInfo] = [
        TimeInfo(time: "9:00 AM", event: "Morning Meeting"),
        TimeInfo(time: "1:00 PM", event: "Lunch"),
        // Add more sample data here
    ]
    
    // MARK: View Life Cycle
    // Load from Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
    }
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeMapTableViewCell.self, forCellReuseIdentifier: "TimeMapTableViewCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeInfoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeMapTableViewCell", for: indexPath) as! TimeMapTableViewCell
        
        let timeInfo = timeInfoArray[indexPath.row]
        cell.configure(with: timeInfo)
        
        return cell
    }

    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}
