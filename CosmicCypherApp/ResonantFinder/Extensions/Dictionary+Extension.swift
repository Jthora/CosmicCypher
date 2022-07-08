//
//  Dictionary+Extension.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/20/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

func + <K, V> (left: [K:V], right: [K:V]) -> [K:V] {
    var new:[K:V] = left
    new.merge(dict: right)
    return new
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
