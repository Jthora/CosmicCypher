//
//  TimeStreamCompositeView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/21/23.
//

import UIKit
import MetalKit

class TimeStreamCompositeView: UIView {
        
    var renderer:TimeStream.Composite.MetalRenderer? = nil
    var metalView:MTKView? = nil
    
    func setup() {
        
        // Create a Metal view in your view controller
        metalView = MTKView(frame: self.bounds)
        metalView!.device = MTLCreateSystemDefaultDevice()
        self.addSubview(metalView!)

        // Initialize a MetalKit renderer
        renderer = TimeStream.Composite.MetalRenderer(view: metalView!)
        metalView!.delegate = renderer
        
        // Setup Renderer
        renderer!.setup()
        
        // Create Auto Layout constraints
        metalView!.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints for top, bottom, left, and right edges
        NSLayoutConstraint.activate([
            metalView!.topAnchor.constraint(equalTo: self.topAnchor),
            metalView!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            metalView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            metalView!.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
