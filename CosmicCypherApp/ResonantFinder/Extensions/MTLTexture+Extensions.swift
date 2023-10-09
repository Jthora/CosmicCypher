//
//  MTLTexture+Extensions.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/4/23.
//

import Foundation
import Metal
import MetalKit
import UIKit
import SpriteKit

typealias MTLMutableTexture = MTLTexture
extension MTLMutableTexture {
    
}

extension MTLTexture {
    func resizeTexture(newWidth: Int, newHeight: Int, device: MTLDevice) -> MTLTexture? {
        // Create a new texture with the desired size and the same format as the original texture
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: self.pixelFormat,
            width: newWidth,
            height: newHeight,
            mipmapped: false
        )
        
        // You can adjust other properties of the texture descriptor as needed
        
        // Create the new texture
        let newTexture = device.makeTexture(descriptor: textureDescriptor)
        
        // Check if the new texture creation was successful
        guard let unwrappedNewTexture = newTexture else {
            return nil
        }
        
        // Create a command buffer and a blit encoder to copy the contents of the old texture to the new one
        if let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer(),
           let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
            // Copy the contents of the old texture to the new one
            blitEncoder.copy(from: self, to: unwrappedNewTexture)
            blitEncoder.endEncoding()
            
            // Commit the command buffer to execute the copy operation
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            
            return unwrappedNewTexture
        } else {
            // Handle the case where command buffer creation failed
            return nil
        }
    }
}

extension MTLTexture {
    func copyTexture(device: MTLDevice) -> MTLTexture? {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: self.pixelFormat,
            width: self.width,
            height: self.height,
            mipmapped: self.mipmapLevelCount > 1
        )
        
        let newTexture = device.makeTexture(descriptor: textureDescriptor)
        
        guard let unwrappedNewTexture = newTexture else {
            return nil
        }
        
        if let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer(),
           let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
            blitEncoder.copy(from: self, to: unwrappedNewTexture)
            blitEncoder.endEncoding()
            
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            
            return unwrappedNewTexture
        } else {
            return nil
        }
    }
}

extension MTLTexture {
    func clearTexture(device: MTLDevice, clearColor: MTLClearColor) {
        if let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer() {
            let renderPassDescriptor = MTLRenderPassDescriptor()
            renderPassDescriptor.colorAttachments[0].texture = self
            renderPassDescriptor.colorAttachments[0].clearColor = clearColor
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].storeAction = .store
            
            guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                print("ERROR: MTLTexture clearTexture can't create renderEncoder")
                return
            }
            // Optionally, you can set up rendering operations here if needed.
            renderEncoder.endEncoding()
            
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
        }
    }
}

extension MTLTexture {
    func toUIImage() -> UIImage? {
        let width = self.width
        let height = self.height
        let rowBytes = self.width * 4 // Assuming 4 bytes per pixel (RGBA8)
        let imageBytes = rowBytes * self.height
        
        var imageBytesArray = [UInt8](repeating: 0, count: imageBytes)
        
        self.getBytes(&imageBytesArray, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo: CGBitmapInfo = [
            .byteOrder32Little,
            .byteOrderDefault,
        ]
        
        guard let context = CGContext(
            data: &imageBytesArray,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: rowBytes,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ), let cgImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

extension MTLTexture {
    func createSKTexture() -> SKTexture? {
        // Check if the Metal texture format is compatible with the desired CGImage format
        guard let cgImage = createCGImage() else {
            return nil
        }
        
        return SKTexture(cgImage: cgImage)
    }
    
    private func createCGImage() -> CGImage? {
        let width = self.width
        let height = self.height
        let rowBytes = self.width * 4 // Assuming 4 bytes per pixel (RGBA8)
        let imageBytes = rowBytes * self.height
        
        var imageBytesArray = [UInt8](repeating: 0, count: imageBytes)
        
        self.getBytes(&imageBytesArray, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo: CGBitmapInfo = [
            .byteOrder32Little,
            .byteOrderDefault,
        ]
        
        guard let context = CGContext(
            data: &imageBytesArray,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: rowBytes,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ), let cgImage = context.makeImage() else {
            return nil
        }
        
        return cgImage
    }
}

