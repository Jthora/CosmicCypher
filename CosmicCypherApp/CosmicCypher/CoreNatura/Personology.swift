//
//  Personology.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

extension Arcana {

    /// 48 Personological Zones
    public enum Personology: Int, CaseIterable {
        
        public static let count:Double = 48
        
        public static func from(degree:Degree) -> Personology {
            let personologyIndex = Int((degree.value/(count/360)).truncatingRemainder(dividingBy: count))
            return Personology(rawValue: personologyIndex)!
        }
        
        /// Pisces-Aries Cusp
        case rebirth
        
        /// Aries
        case child // 1
        case star // 2
        case pioneer // 3
        
        /// Aries-Taurus Cusp
        case power
        
        /// Taurus
        case manifestation
        case teacher
        case natural
        
        /// Taurus-Gemini Cusp
        case energy
        
        /// Gemini
        case freedom
        case newLanguage
        case seeker
        
        /// Gemini-Cancer Cusp
        case magic
        
        /// Cancer
        case empath
        case unconventional
        case pursuader
        
        /// Cancer-Leo Cusp
        case oscillation
        
        /// Leo
        case authority
        case balancedStrength
        case leadership
        
        /// Leo-Virgo Cusp
        case exposure
        
        /// Virgo
        case systemBuilders
        case enigma
        case literalist
        
        /// Virgo-Libra Cusp
        case beauty
        
        /// Libra
        case perfection
        case society
        case thearter
        
        /// Libra-Scorpio Cusp
        case dramaAndCritism
        
        /// Scorpio
        case intensity
        case depth
        case charm
        
        /// Scorpio-Sagittarius Cusp
        case revolution
        
        ///Sagittarius
        case independent
        case originator
        case titan
        
        /// Sagittarius-Capricorn Cusp
        case prophecy
        
        /// Capricorn
        case ruler
        case determination
        case dominance
        
        /// Capricorn-Aquarius Cusp
        case mysteryAndImagination
        
        /// Aquarius
        case genius
        case youthAndEase
        case acceptance
        
        /// Aquarius-Pisces Cusp
        case sensitive
        
        /// Aquarius
        case spirit
        case loner
        case dancersAndDreamers
        

        public var degree:Degree {
            return Degree((Double(self.rawValue) * (360/Personology.count)) - ((360/Personology.count)/2))
        }
    }
}
