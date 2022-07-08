//
//  ReadingsSubScreenPNPA.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 11/26/20.
//

import UIKit

class ReadingsSubScreenPNPA: UIViewController {
    
    // Discernment Graph
    @IBOutlet weak var discernmentGraphView: UIView!
    
    var discernmentCentralPoint:CAShapeLayer? = nil
    var discernmentCentralBlob:CAShapeLayer? = nil
    var discernmentOuterBlob:CAShapeLayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        update()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }

    
    func update() {
        DispatchQueue.main.async {
            
            self.discernmentCentralBlob?.removeFromSuperlayer()
            self.discernmentCentralBlob = nil
            if let dcb = self.createDiscernmentCentralGraphZone() {
                self.discernmentCentralBlob = dcb
                self.discernmentGraphView.layer.addSublayer(self.discernmentCentralBlob!)
            }
            
            self.discernmentOuterBlob?.removeFromSuperlayer()
            self.discernmentOuterBlob = nil
            if let dob = self.createDiscernmentOuterGraphZone() {
                self.discernmentOuterBlob = dob
                self.discernmentGraphView.layer.addSublayer(self.discernmentOuterBlob!)
            }
            
            self.discernmentCentralPoint?.removeFromSuperlayer()
            self.discernmentCentralPoint = nil
            if let cp = self.createDiscernmentCentralPoint() {
                self.discernmentCentralPoint = cp
                self.discernmentGraphView.layer.addSublayer(self.discernmentCentralPoint!)
            }
            
        }
    }
    
    func createDiscernmentOuterGraphZone() -> CAShapeLayer? {
        
        let currentStarChart = StarChart.Core.current
        let selectedNodeTypes = StarChart.Core.selectedNodeTypes
        
        guard selectedNodeTypes.count > 1 else { return nil }
        
        let highestPowerLevel:Double = currentStarChart.produceNaturaIndex(limitList: selectedNodeTypes).highestPowerLevel
        let highestUnlockLevel:Double = currentStarChart.produceNaturaIndex(limitList: selectedNodeTypes).highestUnlockLevel
        let highestEase:Double = currentStarChart.highestAspectConcentration(for: .ease, limitList: selectedNodeTypes)
        let highestDifficulty:Double = currentStarChart.highestAspectConcentration(for: .difficulty, limitList: selectedNodeTypes)
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var x:Double = ((1-highestUnlockLevel) * graphHalfSize)
        let width:Double = (highestPowerLevel + highestUnlockLevel) * graphHalfSize
        var y:Double = ((1-highestDifficulty) * graphHalfSize)
        let height:Double = (highestEase + highestDifficulty) * graphHalfSize
        
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
    
    func createDiscernmentCentralGraphZone() -> CAShapeLayer? {
        
        let currentStarChart = StarChart.Core.current
        let selectedNodeTypes = StarChart.Core.selectedNodeTypes
        
        guard selectedNodeTypes.count > 1 else { return nil }
        
        let averageExaltation:Double = currentStarChart.produceNaturaIndex(limitList: selectedNodeTypes).averagePower
        let averageDebilitation:Double = currentStarChart.produceNaturaIndex(limitList: selectedNodeTypes).averageUnlock
        let averageEase:Double = currentStarChart.averageAspectConcentration(for: .ease, limitList: selectedNodeTypes)
        let averageDifficulty:Double = currentStarChart.averageAspectConcentration(for: .difficulty, limitList: selectedNodeTypes)
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var x:Double = ((1-averageDebilitation) * graphHalfSize)
        let width:Double = (averageDebilitation + averageExaltation) * graphHalfSize
        var y:Double = ((1-averageDifficulty) * graphHalfSize)
        let height:Double = (averageDifficulty + averageEase) * graphHalfSize
        
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
    
    func createDiscernmentCentralPoint() -> CAShapeLayer? {
        
        let currentStarChart = StarChart.Core.current
        let selectedNodeTypes = StarChart.Core.selectedNodeTypes
        
        guard selectedNodeTypes.count > 1 else { return nil }
        
        let averageExaltation:Double = currentStarChart.produceNaturaIndex(limitList: selectedNodeTypes).averagePower
        let averageDebilitation:Double = currentStarChart.produceNaturaIndex(limitList: selectedNodeTypes).averageUnlock
        let averageEase:Double = currentStarChart.averageAspectConcentration(for: .ease, limitList: selectedNodeTypes)
        let averageDifficulty:Double = currentStarChart.averageAspectConcentration(for: .difficulty, limitList: selectedNodeTypes)
        
        let graphSize:Double = Double(discernmentGraphView.bounds.width)
        let graphHalfSize:Double = graphSize/2
        
        var exa = averageExaltation-averageDebilitation
        var ease = averageEase-averageDifficulty
        
        exa *= graphHalfSize
        ease *= graphHalfSize
        exa += graphHalfSize
        ease += graphHalfSize
        
        let x:Double = exa - 4
        let width:Double = 8
        let y:Double = ease - 4
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
