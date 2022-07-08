//
//  String+Extension.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/13/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation

extension String {
    
    func stringRemovingAfter(index: Int) -> String {
        var str = String(self)
        str.removeSubrange(str.index(str.startIndex, offsetBy: index)..<str.endIndex)
        return str
    }
    
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
