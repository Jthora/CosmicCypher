//
//  TimeStreamSceneView.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/6/21.
//

import SceneKit
import SwiftUI


struct TimeStreamSceneView: UIViewRepresentable {
    
    let scene = TimeStreamScene()
    
    var cameraNode: SCNNode = {
        
        // Camera Settings
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 5
        camera.zNear = 1
        camera.zFar = 100
        
        // Camera Node
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        return cameraNode
    }()
    
    var lightNode: SCNNode = {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: 10)
        return lightNode
    }()
    
    var ambientLightNode: SCNNode = {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        return ambientLightNode
    }()
    
    var testNodes:[SCNNode] = {
        var testNodes = [SCNNode]()
        
        for i in 0...10 {
            let offset = Float(i)*2
            //testNodes.append(TimeStream.Node.create(.test, position: SCNVector3(x: (-10.0+offset), y: 0, z: 0), width: 2, height: 2))
        }
        
        return testNodes
    }()
    
    func makeUIView(context: Context) -> SCNView {
        // create and add a camera to the scene
        scene.rootNode.addChildNode(cameraNode)

        // create and add a light to the scene
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        scene.rootNode.addChildNode(ambientLightNode)
        
        for testNode in testNodes {
            scene.rootNode.addChildNode(testNode)
        }
        
        // retrieve the SCNView
        let scnView = SCNView()
        return scnView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        scnView.defaultCameraController.interactionMode = .pan

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = UIColor.gray
    }
}
