//
//  Chevron.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 12/9/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//


import SwiftAA


open class Chevron {
    
    public let node:PlanetNode?
    public var longitude:Degree
    
    public init(node:PlanetNode) {
        self.node = node
        longitude = node.longitude
    }
    
    public init(longitude:Degree) {
        node = nil
        self.longitude = longitude
    }
    
    // Top Bottom Zodiac
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
    
    // Base 4
    public var element:Arcana.Element {
        return Arcana.Element.from(degree: longitude)
    }
    public var subElement:Arcana.Element {
        return Arcana.Element.subFrom(degree: longitude)
    }
    
    // Base 8
    public var natura:Arcana.Natura {
        return Arcana.Natura.from(degree: longitude)
    }
    public var subNatura:Arcana.Natura {
        return Arcana.Natura.subFrom(degree: longitude)
    }
    
    // Base 12 [even] 30º
    public var zodiac:Arcana.Zodiac {
        return Arcana.Zodiac.from(degree: longitude)
    }
    public var subZodiac:Arcana.Zodiac {
        return Arcana.Zodiac.subFrom(degree: longitude)
    }
    
    // Base 12(24) [odd] 30º
    public var cusp:Arcana.Cusp {
        return Arcana.Cusp.from(degree: longitude)
    }
    public var subCusp:Arcana.Cusp {
        return Arcana.Cusp.subFrom(degree: longitude)
    }
    
    // Base 36 [even] 10º
    public var decan:Arcana.Decan {
        return Arcana.Decan.from(degree: longitude)
    }
    public var subDecan:Arcana.Decan {
        return Arcana.Decan.subFrom(degree: longitude)
    }
    
    // Base 8 Distribution
    public var naturaDistribution:Double {
        return abs(subNaturaDistribution-1)
    }
    public var subNaturaDistribution:Double {
        let value = abs((((longitude.value-7.5)/360)*24).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    // Base 12 Distribution
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
    
    // Base 24 Distribution
    struct CuspDistribution {
        let cusp: Arcana.Cusp
        let subCusp: Arcana.Cusp
        let cuspPercentage: Double
        let subCuspPercentage: Double
    }
    
    
    
    
    public var cuspDistribution:Double {
        return abs(subZodiacDistribution-1)
    }
    public var subCuspDistribution:Double {
        
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
    
    // Base 36 Decan Distribution
    public struct DecanDistribution {
        let decan: Arcana.Decan
        let subDecan: Arcana.Decan
        let decanPercentage: Double
        let subDecanPercentage: Double
    }
    let totalDegrees:Double = 360
    let decansCount:Double = 36
    let degreePerDecan:Double = 10
    public func calculateDecanDistribution() -> DecanDistribution {
        
        var degrees = longitude.value.truncatingRemainder(dividingBy: 360)
        if degrees < 0 {
            degrees += 360
        }
        
        var distribution: DecanDistribution
        
        var decan1Index = (degrees / degreePerDecan).truncatingRemainder(dividingBy: decansCount)
        var decan2Index = (decan1Index + 1).truncatingRemainder(dividingBy: decansCount)
        
        if decan1Index < 0 { decan1Index += decansCount }
        if decan2Index < 0 { decan2Index += decansCount }
        
        let remainder = degrees.truncatingRemainder(dividingBy: degreePerDecan)
        let percentageForDecan1 = 1.0 - Double(remainder) / Double(degreePerDecan)
        let percentageForDecan2 = 1.0 - percentageForDecan1
        
        let decan1Enum = Arcana.Decan(rawValue: Int(decan1Index))!
        let decan2Enum = Arcana.Decan(rawValue: Int(decan2Index))!
        
        distribution = DecanDistribution(decan: decan1Enum,
                                        subDecan: decan2Enum,
                                        decanPercentage: percentageForDecan1 * 100,
                                        subDecanPercentage: percentageForDecan2 * 100)
        
        return distribution
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
    
    public var topZodiacDistribution:Double {
        if zodiac == topZodiac {
            return zodiacDistribution
        } else {
            return subZodiacDistribution
        }
    }
    
    public var bottomZodiacDistribution:Double {
        if zodiac == bottomZodiac {
            return zodiacDistribution
        } else {
            return subZodiacDistribution
        }
    }
}
