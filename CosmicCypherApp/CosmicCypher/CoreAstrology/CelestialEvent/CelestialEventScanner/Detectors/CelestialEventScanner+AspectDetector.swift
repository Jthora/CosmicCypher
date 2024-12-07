//
//  CelestialEventScanner+AspectDetector.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Aspect Detector
extension CelestialEventScanner {
    // Aspect Detector
    class AspectDetector {
        static func findAspectsWithinOrb(aspectTypes:[CoreAstrology.AspectType], on date:Date, onProgress:((_ subScanProgress:Float)->Void)? = nil) -> [CoreAstrology.Aspect] {
            
            DispatchQueue.main.async {
                onProgress?(0)
            }
            
            /// Loop through aspects
            var aspects: [CoreAstrology.Aspect] = []
            for (i,aspectType) in aspectTypes.enumerated() {
                
                /// Report Progress Bar
                DispatchQueue.main.async {
                    let subScanProgress:Float = Float(i) / Float(aspectTypes.count)
                    onProgress?(subScanProgress)
                }
                
                /// Aspect
                guard let aspect = aspectType.aspect(for: date) else {
                    continue
                }
                aspects.append(aspect)
            }
            
            /// Report to Progress Bar
            DispatchQueue.main.async {
                onProgress?(1)
            }
            return aspects
        }
    }
}
