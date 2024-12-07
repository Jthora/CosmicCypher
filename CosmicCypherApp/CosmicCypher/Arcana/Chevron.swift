//
//  Chevron.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/9/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import SwiftAA


class Chevron {
    
    let node:AstrologicalNode?
    var longitude:Degree
    
    init(node:AstrologicalNode) {
        self.node = node
        longitude = node.realLongitude
    }
    
    init(longitude:Degree) {
        node = nil
        self.longitude = longitude
    }
    
    var zodiac:Arcana.Zodiac {
        return Arcana.Zodiac.from(degree: longitude)
    }
    var subZodiac:Arcana.Zodiac {
        return Arcana.Zodiac.subFrom(degree: longitude)
    }
    var zodiacDistribution:Double {
        return abs(subZodiacDistribution-1)
    }
    var subZodiacDistribution:Double {
        let value = abs(((longitude.value/360)*12).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    var decan:Arcana.Decan {
        return Arcana.Decan.from(degree: longitude)
    }
    var subDecan:Arcana.Decan {
        return Arcana.Decan.subFrom(degree: longitude)
    }
    var decanDistribution:Double {
        return 1-subNaturaDistribution
    }
    var subDecanDistribution:Double {
        let value = ((longitude.value.truncatingRemainder(dividingBy: 360/36)-(360/72))/(360/72))
        return value > 0 ? value : 1 + value
    }
    
    var natura:Arcana.Natura {
        return Arcana.Natura.from(degree: longitude)
    }
    var subNatura:Arcana.Natura {
        return Arcana.Natura.subFrom(degree: longitude)
    }
    var naturaDistribution:Double {
        return abs(subNaturaDistribution-1)
    }
    var subNaturaDistribution:Double {
        let value = abs((((longitude.value-7.5)/360)*24).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    var element:Arcana.Element {
        return Arcana.Element.from(degree: longitude)
    }
    var subElement:Arcana.Element {
        return Arcana.Element.subFrom(degree: longitude)
    }
    var elementDistribution:Double {
        return abs(subNaturaDistribution-1)
    }
    var subElementDistribution:Double {
        let value = abs((((longitude.value)/360)*12).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    var unlockLevel:Double? {
        guard let powerLevel = powerLevel else {return nil}
        return 1-powerLevel
    }
    var powerLevel:Double? {
        guard let exaltation = exaltation else {return nil}
        // -180 to 180: (facingAngle - angleOfTarget + 180 + 360) % 360 - 180
        // 0 - 360: (facingAngle - angleOfTarget + 180 + 360) % 360
        let angleOffset = (((longitude.value - exaltation.value) + 180 + 180 + 360).truncatingRemainder(dividingBy: 360) - 180)
        let powerLevel = abs(angleOffset)/180
        return powerLevel
    }
    var exaltation:Degree? {
        return body?.exaltation
    }
    var body:Astrology.AspectBody? {
        return node?.aspectBody
    }
    
    
}
