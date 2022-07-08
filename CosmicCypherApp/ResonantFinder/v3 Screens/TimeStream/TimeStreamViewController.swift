//
//  TimeStreamViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/1/20.
//

import UIKit
import SpriteKit

class TimeStreamViewController: UIViewController {

    @IBOutlet weak var spriteKitView: SKView!
    
    var scene:SKScene? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimeStreamVisualizer()
    }
    
    func setupTimeStreamVisualizer() {
        
        self.scene = SKScene(size: self.spriteKitView.frame.size)
        spriteKitView.presentScene(scene)
        
        let starChart = StarChart(date: Date())
        let aspect = starChart.aspects.first!
        let testSprite = SpriteNodeCosmicEvent(aspect: aspect, primaryBodyLongitude: 0, secondaryBodyLongitude: 0, size: CGSize(width: 100, height: 100))!
        
        
        testSprite.position = CGPoint(x: self.scene!.size.width/2, y: self.scene!.size.height/2)
        
        scene!.addChild(testSprite)
    }
    
    
    func setupTimeStreamSpriteTiles() {
        
        //sceneView.scene?.rootNode.addChildNode()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
