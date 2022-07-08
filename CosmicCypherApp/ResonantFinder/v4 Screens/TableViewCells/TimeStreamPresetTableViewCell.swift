//
//  TimeStreamPresetTableViewCell.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/2/22.
//

import Foundation
import UIKit

class TimeStreamPresetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
}

