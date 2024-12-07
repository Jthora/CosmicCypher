//
//  Arcana.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

open class Arcana {
    
    public var degree:Degree {
        didSet {
            setup()
        }
    }
    
    public var personology:Personology
    public var chevron:Chevron
    public var decan:Decan
    
    public var element:Element? {
        return chevron.natura.element
    }
    public var force:Force? {
        return chevron.natura.force
    }
    public var duality:Duality? {
        return chevron.natura.duality
    }
    
    public var zodiac:Zodiac {
        return decan.zodiac
    }
    
    public init(degree:Degree) {
        self.degree = degree
        personology = Personology.from(degree: degree)
        chevron = Chevron(longitude: degree)
        decan = Decan.from(degree: degree)
    }
    
    public func setup() {
        personology = Personology.from(degree: degree)
        chevron = Chevron(longitude: degree)
        decan = Decan.from(degree: degree)
    }
}
