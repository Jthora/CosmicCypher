//
//  TimeMapTableViewCell.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation
import UIKit

class TimeMapTableViewCell: UITableViewCell {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        // Customize label properties (font, color, etc.) as needed
        return label
    }()
    
    let eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        // Customize label properties (font, color, etc.) as needed
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(timeLabel)
        addSubview(eventLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            eventLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            eventLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            eventLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            eventLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with timeInfo: TimeMapTableViewController.TimeInfo) {
        timeLabel.text = timeInfo.time
        eventLabel.text = timeInfo.event
        // Customize cell content based on the TimeInfo structure
    }
}
