//
//  Chevron.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/9/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//


import SwiftAA


open class Chevron {
    
    public let node:AstrologicalNode?
    public var longitude:Degree
    
    public init(node:AstrologicalNode) {
        self.node = node
        longitude = node.longitude
    }
    
    public init(longitude:Degree) {
        node = nil
        self.longitude = longitude
    }
    
    public var zodiac:Arcana.Zodiac {
        return Arcana.Zodiac.from(degree: longitude)
    }
    public var subZodiac:Arcana.Zodiac {
        return Arcana.Zodiac.subFrom(degree: longitude)
    }
    public var zodiacDistribution:Double {
        return abs(subZodiacDistribution-1)
    }
    public var subZodiacDistribution:Double {
        
        let l:Double
        if longitude.value < 0 {
            l = longitude.value+360
        } else {
            l = longitude.value.truncatingRemainder(dividingBy: 360)
        }
        let a = l/360
        let b = a*12
        let c = b.truncatingRemainder(dividingBy: 1)
        let d = c-0.5
        let e = abs(d)
        
        let value = e
        return value > 0 ? value : 1 + value
    }
    
    public var topZodiac:Arcana.Zodiac {
        switch zodiac.element {
        case .air, .fire: return zodiac
        case .earth, .water: return subZodiac
        }
    }
    public var bottomZodiac:Arcana.Zodiac {
        switch subZodiac.element {
        case .air, .fire: return zodiac
        case .earth, .water: return subZodiac
        }
    }
    
    public var decan:Arcana.Decan {
        return Arcana.Decan.from(degree: longitude)
    }
    public var subDecan:Arcana.Decan {
        return Arcana.Decan.subFrom(degree: longitude)
    }
    public var decanDistribution:Double {
        return 1-subNaturaDistribution
    }
    public var subDecanDistribution:Double {
        let value = ((longitude.value.truncatingRemainder(dividingBy: 360/36)-(360/72))/(360/72))
        return value > 0 ? value : 1 + value
    }
    
    public var natura:Arcana.Natura {
        return Arcana.Natura.from(degree: longitude)
    }
    public var subNatura:Arcana.Natura {
        return Arcana.Natura.subFrom(degree: longitude)
    }
    public var naturaDistribution:Double {
        return abs(subNaturaDistribution-1)
    }
    public var subNaturaDistribution:Double {
        let value = abs((((longitude.value-7.5)/360)*24).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    public var element:Arcana.Element {
        return Arcana.Element.from(degree: longitude)
    }
    public var subElement:Arcana.Element {
        return Arcana.Element.subFrom(degree: longitude)
    }
    public var elementDistribution:Double {
        return abs(subElementDistribution-1)
    }
    public var subElementDistribution:Double {
        //let value = abs((((longitude.value)/360)*12).truncatingRemainder(dividingBy: 1)-0.5)
        
        let l:Double
        if longitude.value < 0 {
            l = longitude.value+360
        } else {
            l = longitude.value.truncatingRemainder(dividingBy: 360)
        }
        let a = l/360
        let b = a*12
        let c = b.truncatingRemainder(dividingBy: 1)
        let d = c-0.5
        let e = abs(d)
        
        let value = e
        return value > 0 ? value : 1 + value
    }
    
    public var nodeType:CoreAstrology.AspectBody.NodeType? {
        return node?.nodeType
    }
    
    
}
