//
//  CoreAstrology+AspectRelationType.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import SwiftAA
import Foundation

// MARK: Aspect Relation Type
extension CoreAstrology {
    public enum AspectRelationType: Int, CaseIterable, Codable {
        
        // init AspectRelationType (based on distance between AspectBodies)
        public init?(nodeDistance:Degree, limitTypes:[AspectRelationType] = AspectRelationType.allCases) {
            //print("creating aspect relation for nodeDistance: \(nodeDistance)")
            
            // Setup
            var relationType:AspectRelationType? = nil
            
            // Iterate through all Types
            for thisRelationType in limitTypes {
                //print("checking for relationType: \(thisRelationType.symbol)")
                // If type is within orb
                if thisRelationType.withinOrb(nodeDistance: nodeDistance) {
                    //print("found relationType: \(thisRelationType.symbol)")
                    relationType = thisRelationType
                    break
                }
            }
            
            // if none found, return nil
            guard let type = relationType else {
                //print("no relationType found for nodeDistance: \(nodeDistance)")
                return nil
            }
            
            // Init
            //print("init relationType: \(type.symbol)")
            self = type
        }
        
        // init AspectRelationType (based on )
        public init?(distanceFromOrbCenter:Degree, expectedType:AspectRelationType) {
            //print("creating aspect relation for distanceFromOrbCenter: \(distanceFromOrbCenter)")
            
            //print("checking for relationType: \(expectedType.symbol)")
            // If type is within orb
            if abs(distanceFromOrbCenter) < expectedType.orb {
                //print("found relationType: \(expectedType.symbol)")
                self = expectedType
            } else {
                //print("relationType \(expectedType.symbol) not within distance (return nil)")
                return nil
            }
        }
        
        case conjunction
        case opposition
        
        case sextile
        case trine
        
        case semisquare
        case square
        case bisemisquare
        
        case quintile
        case biquintile
        
        case septile
        case biseptile
        case triseptile
        
        case novile
        case binovile
        case quadranovile
        
        case oneTenth
        case threeTenth
        
        case oneEleventh
        case twoEleventh
        case threeEleventh
        case fourEleventh
        case fiveEleventh
        
        case oneTwelfth // semisextile
        case fiveTwelfth
    }
}
       
extension CoreAstrology.AspectRelationType {
    public var degree:Degree {
        switch self {
        case .conjunction: return 0
        case .opposition: return 180
            
        case .sextile: return 60
        case .trine: return 120
            
        case .semisquare: return 45
        case .square: return 90
        case .bisemisquare: return 135
            
        case .quintile: return 72
        case .biquintile: return 144
            
        case .septile: return 51.4285714286
        case .biseptile: return 102.857142857
        case .triseptile: return 154.285714286
            
        case .novile: return 40
        case .binovile: return 80
        case .quadranovile: return 160
            
        case .oneTenth: return 36
        case .threeTenth: return 108
            
        case .oneEleventh: return 32.72727272727
        case .twoEleventh: return 65.45454545455
        case .threeEleventh: return 98.18181818182
        case .fourEleventh: return 130.90909090909
        case .fiveEleventh: return 163.63636363636
            
        case .oneTwelfth: return 30 // semisextile
        case .fiveTwelfth: return 150 // fiveTwelfth
        }
    }
}

extension CoreAstrology.AspectRelationType {
    public var longDescription: String {
        switch self {
        case .conjunction: return "A conjunction is a powerful aspect representing unity and blending energies."
        case .opposition: return "An opposition indicates a polarity or conflict between energies."
        case .sextile: return "A sextile signifies opportunities and harmonious interactions."
        case .trine: return "A trine represents ease, support, and flowing energy."
        case .semisquare: return "A semisquare represents inner tension and challenges."
        case .square: return "A square signifies tension, challenges, and growth opportunities."
        case .bisemisquare: return "A bisemisquare indicates minor tension and challenges."
        case .quintile: return "A quintile signifies creativity and unique talents."
        case .biquintile: return "A biquintile represents talents and unconventional abilities."
        case .septile: return "A septile signifies subtle influences and spiritual connections."
        case .biseptile: return "A biseptile signifies inner harmony and understanding."
        case .triseptile: return "A triseptile represents mystical connections and inner development."
        case .novile: return "A novile indicates opportunities for inspiration and growth."
        case .binovile: return "A binovile signifies creative potential and unique insights."
        case .quadranovile: return "A quadranovile denotes subtle influences and spiritual connections."
        case .oneTenth: return "An aspect at one-tenth of the circle represents potential growth and new beginnings."
        case .threeTenth: return "An aspect at three-tenths of the circle represents creative endeavors and growth."
        case .oneEleventh: return "An aspect at one-eleventh of the circle signifies unique connections and potential growth."
        case .twoEleventh: return "An aspect at two-elevenths of the circle represents potential growth and unique insights."
        case .threeEleventh: return "An aspect at three-elevenths of the circle signifies connections and potential growth."
        case .fourEleventh: return "An aspect at four-elevenths of the circle represents potential growth and unique connections."
        case .fiveEleventh: return "An aspect at five-elevenths of the circle signifies connections and potential growth."
        case .oneTwelfth: return "A semisextile represents subtle connections and minor harmonies."
        case .fiveTwelfth: return "An aspect at five-twelfths of the circle signifies unique connections and potential growth."
        }
    }
}



extension CoreAstrology.AspectRelationType {
   public func distance(orbitDegreeOffset:Degree) -> Degree {
       return abs(orbitDegreeOffset - self.degree)
   }
   
   public func withinOrb(nodeDistance:Degree) -> Bool {
       let diff = abs(self.degree - nodeDistance)
       let orb = self.orb
       let isWithinOrb = diff < orb
       return isWithinOrb
   }
   
   public var isEasyAspect:Bool {
       switch self {
       case .novile, .binovile, .quadranovile, .oneTwelfth, .sextile, .trine:
           return true
       default:
           return false
       }
   }
   
   public var priority:Double {
       switch self {
       case .conjunction: return 30 // (360*( 1/1 ))/12
       case .opposition: return 15 // (360*( 1/2 ))/12
       case .trine: return 10 // (360*( 1/3 ))/12
       case .square: return 7.5 // (360*( 1/4 ))/12
       case .quintile: return 6 // (360*( 1/5 ))/12
       case .biquintile: return 6 // (360*( 1/5 ))/12
       case .sextile: return 5 // (360*( 1/6 ))/12
       case .septile: return 4.3 // (360*( 1/7 ))/12
       case .biseptile: return 4.2 // (360*( 1/7 ))/12
       case .triseptile: return 4.1 // (360*( 1/7 ))/12
       case .semisquare: return 3.6 // (360*( 1/8 ))/12
       case .bisemisquare: return 3.5 // (360*( 1/8 ))/12
       case .novile: return 3.4 // (360*( 1/9 ))/12
       case .binovile: return 3.3 // (360*( 1/9 ))/12
       case .quadranovile: return 3.2 // (360*( 1/9 ))/12
       case .oneTenth: return 3.1 // (360*( 1/10 ))/12
       case .threeTenth: return 3 // (360*( 1/10 ))/12
       case .oneEleventh: return 2.7  // (360*( 1/11 ))/12
       case .twoEleventh: return 2.6  // (360*( 1/11 ))/12
       case .threeEleventh: return 2.5  // (360*( 1/11 ))/12
       case .fourEleventh: return 2.4  // (360*( 1/11 ))/12
       case .fiveEleventh: return 2.3  // (360*( 1/11 ))/12
       case .oneTwelfth: return 2.2 // (360*( 1/12 ))/12
       case .fiveTwelfth: return 2.1 // (360*( 1/12 ))/12
       }
   }
   
   public var orb:Degree {
       switch self {
       case .conjunction: return 30 // (360*( 1/1 ))/12
       case .opposition: return 15 // (360*( 1/2 ))/12
       case .trine: return 10 // (360*( 1/3 ))/12
       case .square: return 7.5 // (360*( 1/4 ))/12
       case .quintile: return 6 // (360*( 1/5 ))/12
       case .biquintile: return 6 // (360*( 1/5 ))/12
       case .sextile: return 5 // (360*( 1/6 ))/12
       case .septile: return 4.28571428571 // (360*( 1/7 ))/12
       case .biseptile: return 4.28571428571 // (360*( 1/7 ))/12
       case .triseptile: return 4.28571428571 // (360*( 1/7 ))/12
       case .semisquare: return 3.75 // (360*( 1/8 ))/12
       case .bisemisquare: return 3.75 // (360*( 1/8 ))/12
       case .novile: return 3.33333333333 // (360*( 1/9 ))/12
       case .binovile: return 3.33333333333 // (360*( 1/9 ))/12
       case .quadranovile: return 3.33333333333 // (360*( 1/9 ))/12
       case .oneTenth: return 3 // (360*( 1/10 ))/12
       case .threeTenth: return 3 // (360*( 1/10 ))/12
       case .oneEleventh: return 2.72727272727  // (360*( 1/11 ))/12
       case .twoEleventh: return 2.72727272727  // (360*( 1/11 ))/12
       case .threeEleventh: return 2.72727272727  // (360*( 1/11 ))/12
       case .fourEleventh: return 2.72727272727  // (360*( 1/11 ))/12
       case .fiveEleventh: return 2.72727272727  // (360*( 1/11 ))/12
       case .oneTwelfth: return 2.5 // (360*( 1/12 ))/12
       case .fiveTwelfth: return 2.5 // (360*( 1/12 ))/12
       }
   }
   
   public var fraction:String {
       switch self {
       case .conjunction: return "1/1"
       case .opposition: return "1/2"
       case .trine: return "1/3"
       case .square: return "1/4"
       case .quintile: return "1/5"
       case .biquintile: return "2/5"
       case .sextile: return "1/6"
       case .septile: return "1/7"
       case .biseptile: return "2/7"
       case .triseptile: return "3/7"
       case .semisquare: return "1/8"
       case .bisemisquare: return "3/8"
       case .novile: return "1/9"
       case .binovile: return "2/9"
       case .quadranovile: return "4/9"
       case .oneTenth: return "1/10"
       case .threeTenth: return "3/10"
       case .oneEleventh: return "1/11"
       case .twoEleventh: return "2/11"
       case .threeEleventh: return "3/11"
       case .fourEleventh: return "4/11"
       case .fiveEleventh: return "5/11"
       case .oneTwelfth: return "1/12"
       case .fiveTwelfth: return "5/12"
       }
   }
   
   public var symbol:String {
       switch self {
       case .conjunction: return "☌"
       case .opposition: return "☍"
       case .trine: return "△"
       case .square: return "☐"
       case .quintile: return "⭐︎"
       case .biquintile: return "⭐︎²"
       case .sextile: return "✱" // ⚹
       case .septile: return "7¹"
       case .biseptile: return "7²"
       case .triseptile: return "7³"
       case .semisquare: return "8¹"
       case .bisemisquare: return "8³"
       case .novile: return "9¹"
       case .binovile: return "9²"
       case .quadranovile: return "9⁴"
       case .oneTenth: return "10¹"
       case .threeTenth: return "10³"
       case .oneEleventh: return "11¹"
       case .twoEleventh: return "11²"
       case .threeEleventh: return "11³"
       case .fourEleventh: return "11⁴"
       case .fiveEleventh: return "11⁵"
       case .oneTwelfth: return "12¹"
       case .fiveTwelfth: return "12⁵"
       }
   }
   
   public var imageName:String {
       switch self {
       case .conjunction: return "AstrologyIcon_Aspect_Conjunct"
       case .opposition: return "AstrologyIcon_Aspect_Opposition"
       case .trine: return "AstrologyIcon_Aspect_Trine"
       case .square: return "AstrologyIcon_Aspect_Square"
       case .quintile, .biquintile: return "AstrologyIcon_Aspect_Fifth"
       case .sextile: return "AstrologyIcon_Aspect_Sextile"
       case .septile, .biseptile, .triseptile: return "AstrologyIcon_Aspect_Seventh"
       case .semisquare, .bisemisquare: return "AstrologyIcon_Aspect_Eighth"
       case .novile, .binovile, .quadranovile: return "AstrologyIcon_Aspect_Ninth"
       case .oneTenth, .threeTenth: return "AstrologyIcon_Aspect_Tenth"
       case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return "AstrologyIcon_Aspect_Eleventh"
       case .oneTwelfth, .fiveTwelfth: return "AstrologyIcon_Aspect_Twelfth"
       }
   }
   
   public var image:StarKitImage {
       switch self {
       case .conjunction: return StarKitAssets.Images.AspectSymbols.conjunct
       case .opposition: return StarKitAssets.Images.AspectSymbols.opposition
       case .trine: return StarKitAssets.Images.AspectSymbols.trine
       case .square: return StarKitAssets.Images.AspectSymbols.square
       case .quintile, .biquintile: return StarKitAssets.Images.AspectSymbols.fifth
       case .sextile: return StarKitAssets.Images.AspectSymbols.sextile
       case .septile, .biseptile, .triseptile: return StarKitAssets.Images.AspectSymbols.seventh
       case .semisquare, .bisemisquare: return StarKitAssets.Images.AspectSymbols.eighth
       case .novile, .binovile, .quadranovile: return StarKitAssets.Images.AspectSymbols.ninth
       case .oneTenth, .threeTenth: return StarKitAssets.Images.AspectSymbols.tenth
       case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return StarKitAssets.Images.AspectSymbols.eleventh
       case .oneTwelfth, .fiveTwelfth: return StarKitAssets.Images.AspectSymbols.twelfth
       }
   }
   
   public var defaultDescription:String {
       switch self {
       case .conjunction: return "Relationships, the blurring of differences"
       case .opposition: return "Relationships, divided loyalties"
           
       case .sextile: return "Friendly, with some talent, ease, and oomph"
       case .trine: return "Support, pleasure"
           
       case .semisquare: return "Friction, prompt action to reduce friction"
       case .square: return "Tension, expect difficulty and growth"
       case .bisemisquare: return ""
           
       case .oneTwelfth: return "Dissociation, helping another"
       case .fiveTwelfth: return "Challenging, misunderstanding and difference"
           
       case .quintile: return "Unleashed talent, use of creative energy"
       case .biquintile: return "Unleashed talent, use of creative energy"
           
       case .septile: return ""
       case .biseptile: return ""
       case .triseptile: return ""
           
       case .novile: return "Initiation, successful"
       case .binovile: return "Initiation, successful"
       case .quadranovile: return "Initiation, successful"
           
       default: return ""
       }
   }
}
