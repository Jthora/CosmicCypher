//
//  TimeStreamSpectrogramView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/23/23.
//

import UIKit
import Metal
import MetalKit

public class TimeStreamSpectrogramView: UIView {
    
    public var spectrogram:TimeStreamSpectrogram? = nil
    public var metalView:MTKView? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup() {
        
        // Create a Metal view in your view controller
        metalView = MTKView(frame: self.bounds)
        metalView!.device = MTLCreateSystemDefaultDevice()
        self.addSubview(metalView!)
        
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
