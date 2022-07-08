//
//  TimeStreamSpriteMask.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/20/22.
//

import Foundation
import SpriteKit


// Mask Node
public typealias TimeStreamEffectNodeSet = [CoreAstrology.AspectBody.NodeType:TimeStreamEffectNode]
public class TimeStreamEffectNode: SKEffectNode {
    
    var inputImage: CIImage
    var inputMaskImage: CIImage
    var maskFilter: CIFilter?
    
    init(imageStrip: TimeStream.ImageStrip, size:CGSize, option: TimeStreamEffectNode.Option = .gradient(.whiteWithAlpha(.normal))) throws {
        // Reference image
        let sourceMaskImage:UIImage = option.uiImage()
        
        // Setup mask filter
        self.inputImage = CIImage(cgImage: imageStrip.uiImage.cgImage!)
        self.inputMaskImage = CIImage(cgImage: try sourceMaskImage.resized(to: size, with: .coreImage).cgImage!)
        self.maskFilter = CIFilter.blendWithMask(inputImage: inputImage, inputBackgroundImage: .white, inputMaskImage: inputMaskImage)
        
        super.init()
        
        // Set the filter
        self.filter = maskFilter
        self.shouldEnableEffects = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TimeStreamEffectNode {
    enum Option {
        case gradient(_ gradientOption:GradientOption)
        enum GradientOption {
            case whiteWithAlpha(_ mirrorOption:MirrorOption)
            case blackWithAlpha(_ mirrorOption:MirrorOption)
            case blackToWhite(_ mirrorOption:MirrorOption)
            enum MirrorOption {
                case normal
                case mirror
            }
        }
        
        func uiImage() -> UIImage {
            switch self {
            case .gradient(let gradientOption):
                switch gradientOption {
                case .whiteWithAlpha(let mirrorOption):
                    switch mirrorOption {
                    case .normal: return Option.OptionImage.gradientStrip_whiteWithAlphaGradient_128y
                    case .mirror: return Option.OptionImage.gradientStrip_whiteWithAlphaGradient_mirror_128y
                    }
                case .blackWithAlpha(let mirrorOption):
                    switch mirrorOption {
                    case .normal: return Option.OptionImage.gradientStrip_blackWithAlphaGradient_128y
                    case .mirror: return Option.OptionImage.gradientStrip_blackWithAlphaGradient_mirror_128y
                    }
                case .blackToWhite(let mirrorOption):
                    switch mirrorOption {
                    case .normal: return Option.OptionImage.gradientStrip_blackToWhiteGradient_128y
                    case .mirror: return Option.OptionImage.gradientStrip_blackToWhiteGradient_mirror_128y
                    }
                }
            }
        }
        
        struct OptionImage {
            static let gradientStrip_whiteWithAlphaGradient_128y = UIImage(named: "gradientStrip-whiteWithAlphaGradient-128y")!
            static let gradientStrip_whiteWithAlphaGradient_mirror_128y = UIImage(named: "gradientStrip-whiteWithAlphaGradient-mirror-128y")!
            static let gradientStrip_blackWithAlphaGradient_128y = UIImage(named: "gradientStrip-blackWithAlphaGradient-128y")!
            static let gradientStrip_blackWithAlphaGradient_mirror_128y = UIImage(named: "gradientStrip-blackWithAlphaGradient-mirror-128y")!
            static let gradientStrip_blackToWhiteGradient_128y = UIImage(named: "gradientStrip-blackToWhiteGradient-128y")!
            static let gradientStrip_blackToWhiteGradient_mirror_128y = UIImage(named: "gradientStrip-blackToWhiteGradient-mirror-128y")!
        }
    }
}
