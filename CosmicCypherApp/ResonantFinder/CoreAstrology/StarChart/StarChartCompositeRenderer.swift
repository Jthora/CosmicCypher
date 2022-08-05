//
//  StarChartCompositeRenderer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/26/22.
//

import UIKit

extension StarChart.Composite {
    static func render(starChart: StarChart,
                       size:CGSize,
                       nodeTypes: [CoreAstrology.AspectBody.NodeType],
                       onProgress:((_ completion:Float)->Void)? = nil,
                       onComplete:((_ compositeImage:CGImage)->Void)? = nil,
                       onStop:(()->Void)? = nil) {
        Renderer.renderComposite(starChart: starChart,
                                 size:size,
                                 nodeTypes: nodeTypes,
                                 onProgress:onProgress,
                                 onComplete:onComplete,
                                 onStop:onStop)
    }
    class Renderer {
        
        static let operationQueue: OperationQueue = {
            let op = OperationQueue()
            op.isSuspended = false
            return op
        } ()
        static var activeRenderOperation:StarChartCompositeRenderOperation? = nil
        
        static func renderComposite(starChart: StarChart,
                                    size:CGSize,
                                    nodeTypes: [CoreAstrology.AspectBody.NodeType],
                                    onProgress:((_ completion:Float)->Void)? = nil,
                                    onComplete:((_ compositeImage:CGImage)->Void)? = nil,
                                    onStop:(()->Void)? = nil) {
            operationQueue.cancelAllOperations()
            operationQueue.addOperation(StarChartCompositeRenderOperation(starChart: starChart,
                                                                          size: size,
                                                                          nodeTypes: nodeTypes,
                                                                          onProgress: onProgress,
                                                                          onComplete: onComplete,
                                                                          onStop: onStop))
        }
        
        static func cancel() {
            operationQueue.cancelAllOperations()
        }
        
    }
}


class StarChartCompositeRenderOperation: Operation {
    
    let starChart: StarChart
    let size: CGSize
    let nodeTypes: [CoreAstrology.AspectBody.NodeType]
    var onProgress:((_ completion:Float)->Void)?
    var onComplete:((_ compositeImage:CGImage)->Void)?
    var onStop:(()->Void)?
    
    init(starChart: StarChart,
         size:CGSize,
         nodeTypes: [CoreAstrology.AspectBody.NodeType],
         onProgress:((_ completion:Float)->Void)? = nil,
         onComplete:((_ compositeImage:CGImage)->Void)? = nil,
         onStop:(()->Void)? = nil) {
        self.starChart = starChart
        self.size = size
        self.nodeTypes = nodeTypes
        self.onProgress = onProgress
        self.onComplete = onComplete
        self.onStop = onStop
    }
  
    override func main() {
        print("Render StarChart Composite")
        // initial cancel check
        if isCancelled { return }

        let alignments = starChart.alignments.values.filter { nodeTypes.contains($0.nodeType) }

        let width = Int(size.width)
        let height = Int(size.height)

        let linkRing:CGImage = StarChart.DiskImageType.linkRing.cgImage
        let informalChevrons:CGImage = StarChart.DiskImageType.informal.cgImage
        let powerChevrons:CGImage = StarChart.DiskImageType.formal_power.cgImage
        let unlockChevrons:CGImage = StarChart.DiskImageType.formal_unlock.cgImage
        let differencialChevrons:CGImage = StarChart.DiskImageType.differencial.cgImage

        var linkRingMask:CGImage = CGImage.blankMask(width: width, height: height)
        var informalChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        var powerChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        var unlockChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        var differencialChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)

        var ct:Float = 0
        let total:Float = Float(alignments.count)
        
        DispatchQueue.main.async {
            self.onProgress?(ct/total)
        }

        for alignment in alignments {
            print("Render StarChart Composite Alignment [\(Int(ct))/\(Int(total))]")
            
            if isCancelled {
                onStop?()
                return
            }
            
            let additionalLinkRingMask = StarChart.DiskMaskType.orb3_75.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            linkRingMask = linkRingMask.mergeMask(with: additionalLinkRingMask)
            ct += 0.2
            DispatchQueue.main.async {
                self.onProgress?(ct/total)
            }
          
            if isCancelled {
                onStop?()
                return
            }
            
            let additionalInformalChevronsMask = StarChart.DiskMaskType.orb3_75.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            informalChevronsMask = informalChevronsMask.mergeMask(with: additionalInformalChevronsMask)
            ct += 0.2
            DispatchQueue.main.async {
                self.onProgress?(ct/total)
            }
          
            if isCancelled {
                onStop?()
                return
            }
            
            let additionalPowerChevronsMask = StarChart.DiskMaskType.orb1_875.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            powerChevronsMask = powerChevronsMask.mergeMask(with: additionalPowerChevronsMask)
            ct += 0.2
            DispatchQueue.main.async {
                self.onProgress?(ct/total)
            }
          
            if isCancelled {
                onStop?()
                return
            }
            
            let additionalUnlockChevronsMask = StarChart.DiskMaskType.orb7_5.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            unlockChevronsMask = unlockChevronsMask.mergeMask(with: additionalUnlockChevronsMask)
            ct += 0.2
            DispatchQueue.main.async {
                self.onProgress?(ct/total)
            }

            if isCancelled {
                onStop?()
                return
            }
            
            let additionalDifferencialRingMask = StarChart.DiskMaskType.orb3_75.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            differencialChevronsMask = differencialChevronsMask.mergeMask(with: additionalDifferencialRingMask)
            ct += 0.2
            DispatchQueue.main.async {
                self.onProgress?(ct/total)
            }
        }
        
        let maskedLinkRing = linkRing.masking(linkRingMask)!
        let maskedInformalChevrons = informalChevrons.masking(informalChevronsMask)!
        let maskedPowerChevrons = powerChevrons.masking(powerChevronsMask)!
        let maskedUnlockChevrons = unlockChevrons.masking(unlockChevronsMask)!
        let maskedDifferencialChevrons = differencialChevrons.masking(differencialChevronsMask)!

        let combinedImage = CGImage.blank(width: width, height: height).merge(with: [maskedLinkRing,
                                                                              maskedInformalChevrons,
                                                                              maskedPowerChevrons,
                                                                              maskedUnlockChevrons,
                                                                              maskedDifferencialChevrons],
                                                                       blendMode: .normal)
        
            print("RenderComplete StarChart Composite Alignment [\(Int(ct))/\(Int(total))]")
      
        // cancel check
        if isCancelled {
            onStop?()
            return
        }
        
        // update UI
        DispatchQueue.main.async {
            self.onComplete?(combinedImage)
        }
    }
}
