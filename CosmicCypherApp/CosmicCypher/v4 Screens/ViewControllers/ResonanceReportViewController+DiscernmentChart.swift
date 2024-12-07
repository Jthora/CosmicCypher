//
//  ResonanceReportViewController+DiscernmentChart.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 8/5/22.
//

import UIKit


extension ResonanceReportViewController {
    // MARK: Discernment Graph
    // Outer Cirlce
    func createDiscernmentOuterGraphZone() -> CAShapeLayer? {
        
        let selectedAspectBodies = StarChart.Core.selectedNodeTypes
        guard selectedAspectBodies.count > 1 else { return nil }
        
        let maxExaltation:Double = StarChart.Core.maxExaltation
        let maxDebilitation:Double = StarChart.Core.maxDebilitation
        let maxRise:Double = StarChart.Core.maxRise
        let maxFall:Double = StarChart.Core.maxFall
        
        guard !maxExaltation.isNaN && !maxDebilitation.isNaN && !maxRise.isNaN && !maxFall.isNaN else { return nil }
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var x:Double = ((1-maxDebilitation) * graphHalfSize)
        let width:Double = (maxExaltation + maxDebilitation) * graphHalfSize
        var y:Double = ((1-maxFall) * graphHalfSize)
        let height:Double = (maxRise + maxFall) * graphHalfSize
        
        if Int(x) == Int(graphHalfSize) && width < 4 {
            x = graphHalfSize-2
        }
        if Int(y) == Int(graphHalfSize) && height < 4 {
            y = graphHalfSize-2
        }
        
        let rect = CGRect(x: x, y: y, width: max(4,width), height: max(4,height))
        
        let blobPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(min(width/2, height/2)))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blobPath.cgPath
        shapeLayer.compositingFilter = CompositingFilterStrings.overlayBlendMode.rawValue
        
        
        shapeLayer.anchorPoint = discernmentGraphView.center
        
        // ROTATE TRANSFORM!
        //shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Degree(45).inRadians.value), 0.0, 0.0, 1.0)

        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 1.0

        return shapeLayer
    }
    
    // Central Cirlce
    func createDiscernmentCentralGraphZone() -> CAShapeLayer? {
        
        let selectedPlanets = StarChart.Core.selectedPlanets
        guard selectedPlanets.count > 1 else { return nil }
        
        let maxExaltation:Double = StarChart.Core.maxExaltation
        let maxDebilitation:Double = StarChart.Core.maxDebilitation
        let maxRise:Double = StarChart.Core.maxRise
        let maxFall:Double = StarChart.Core.maxFall
        
        guard !maxExaltation.isNaN && !maxDebilitation.isNaN && !maxRise.isNaN && !maxFall.isNaN else { return nil }
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var x:Double = ((1-maxDebilitation) * graphHalfSize)
        let width:Double = (maxDebilitation + maxExaltation) * graphHalfSize
        var y:Double = ((1-maxFall) * graphHalfSize)
        let height:Double = (maxFall + maxRise) * graphHalfSize
        
        if x == 0 && width < 4 {
            x = -2
        }
        if y == 0 && height < 4 {
            y = -2
        }
        
        let rect = CGRect(x: x, y: y, width: max(4,width), height: max(4,height))
        
        let blobPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(min(width/2, height/2)))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blobPath.cgPath
        shapeLayer.compositingFilter = CompositingFilterStrings.overlayBlendMode.rawValue
        
        
        shapeLayer.anchorPoint = discernmentGraphView.center
        
        // ROTATE TRANSFORM!
        //shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Degree(45).inRadians.value), 0.0, 0.0, 1.0)

        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        shapeLayer.lineWidth = 2.0

        return shapeLayer
    }
    
    // Central Point
    func createDiscernmentCentralPoint() -> CAShapeLayer? {
        
        let selectedAspectBodies = StarChart.Core.selectedNodeTypes
        guard selectedAspectBodies.count > 1 else { return nil }
        
        let averageExaltation:Double = StarChart.Core.averageExaltation
        let averageDebilitation:Double = StarChart.Core.averageDebilitation
        let averageRise:Double = StarChart.Core.averageRise
        let averageFall:Double = StarChart.Core.averageFall
        
        guard !averageExaltation.isNaN && !averageDebilitation.isNaN && !averageRise.isNaN && !averageFall.isNaN else { return nil }
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var exa = averageExaltation-averageDebilitation
        var rise = averageRise-averageFall
        
        exa *= graphHalfSize
        rise *= graphHalfSize
        exa += graphHalfSize
        rise += graphHalfSize
        
        let x:Double = exa - 4
        let width:Double = 8
        let y:Double = rise - 4
        let height:Double = 8
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let blobPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(min(width/2, height/2)))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blobPath.cgPath
        shapeLayer.compositingFilter = CompositingFilterStrings.overlayBlendMode.rawValue
        
        
        shapeLayer.anchorPoint = discernmentGraphView.center
        
        // ROTATE TRANSFORM!
        //shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Degree(45).inRadians.value), 0.0, 0.0, 1.0)

        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(1).cgColor
        shapeLayer.lineWidth = 2.0

        return shapeLayer
    }
}
