//
//  Arcana.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

class Arcana {
    
    var degree:Degree {
        didSet {
            setup()
        }
    }
    
    var personology:Personology
    var chevron:Chevron
    var decan:Decan
    
    var element:Element? {
        return chevron.natura.element
    }
    var force:Force? {
        return chevron.natura.force
    }
    var duality:Duality? {
        return chevron.natura.duality
    }
    var exaltation:Degree? {
        return chevron.exaltation
    }
    var powerLevel:Double? {
        return chevron.powerLevel
    }
    
    var zodiac:Zodiac {
        return decan.zodiac
    }
    
    init(degree:Degree) {
        self.degree = degree
        personology = Personology.from(degree: degree)
        chevron = Chevron(longitude: degree)
        decan = Decan.from(degree: degree)
    }
    
    func setup() {
        personology = Personology.from(degree: degree)
        chevron = Chevron(longitude: degree)
        decan = Decan.from(degree: degree)
    }
}
