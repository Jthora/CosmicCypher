//
//  UITableView+Extension.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/5/22.
//

import Foundation
import UIKit

extension UITableView {
    var lastRow:Int {
        return numberOfRows(inSection: 0) - 1
    }
}
