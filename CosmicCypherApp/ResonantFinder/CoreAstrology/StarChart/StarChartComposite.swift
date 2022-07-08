//
//  StarChartComposite.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/26/22.
//

import SpriteKit

extension StarChart {
    class Composite {
        
    }
    enum DiskImageType {
        case linkRing
        case informal
        case formal_unlock
        case formal_power
        case differencial
        
        var imageName:String {
            switch self {
                case .linkRing: return "cypherDisk_chevron36_linkRing"
                case .informal: return "cypherDisk_chevron36_informal"
                case .formal_power: return "cypherDisk_chevron36_differencial_power"
                case .formal_unlock: return "cypherDisk_chevron36_differencial_unlockable"
                case .differencial: return "cypherDisk_chevron36_formal"
            }
        }
        
        var cgImage:CGImage {
            return UIImage(named: imageName)!.cgImage!
        }
        
        var texture:SKTexture {
            return SKTexture(cgImage: cgImage)
        }
    }
    
    enum DiskMaskType {
        case orb7_5
        case orb3_75
        case orb1_875
        case orb0_9375
        
        var imageName:String {
            switch self {
                case .orb7_5: return "CosmicAlignment_Mask-7.5DegOrb"
                case .orb3_75: return "CosmicAlignment_Mask-3.75DegOrb"
                case .orb1_875: return "CosmicAlignment_Mask-1.875DegOrb"
                case .orb0_9375: return "CosmicAlignment_Mask-0.9375DegOrb"
            }
        }
        
        var cgImage:CGImage {
            return UIImage(named: imageName)!.cgImage!
        }
        
        var texture:SKTexture {
            return SKTexture(cgImage: cgImage)
        }
    }
}
