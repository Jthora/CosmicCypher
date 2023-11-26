//
//  TimestreamImageGenerator.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

extension TimeStream {
    
    typealias ImageGeneratorOnStartCallback = (() -> Void)
    typealias ImageGeneratorOnExitCallback = (() -> Void)
    typealias ImageGeneratorOnSaveCallback = ((_ successfulSaves: Int, _ expectedImageCount: Int) -> Void)
    typealias ImageGeneratorOnCompleteCallback = ((_ successfulSaves: Int, _ expectedImageCount: Int) -> Void)
    typealias ImageGeneratorOnErrorCallback = ((_ errorString: String, _ imagesRendered: Int) -> Void)
    
    public final class ImageGenerator {
        
        private init() {}
        
        public static func generateStrips(timestream: TimeStream, nodeTypes:[CoreAstrology.AspectBody.NodeType]) -> TimeStreamImageStripSet {
            return generateStrips(planetNodeStateTimeline: timestream.planetNodeStateTimeline(nodeTypes: nodeTypes),
                                  colorRenderMode: timestream.colorRenderMode,
                                  dataMetric: timestream.dataMetric)
        }
        
        public static func generateStrips(planetNodeStateTimeline:PlanetNodeStateTimeline,
                                   colorRenderMode: TimeStream.ColorRenderMode,
                                   dataMetric: TimeStream.DataMetric) -> TimeStreamImageStripSet {
            var timeStreamImageStrips = TimeStreamImageStripSet()
            
            for (nodeType,planetNodeStates) in planetNodeStateTimeline {
                guard let timeStreamImageStrip = generateStrip(planetNodeStates: planetNodeStates,
                                                               nodeType: nodeType,
                                                               colorRenderMode: colorRenderMode,
                                                               dataMetric: dataMetric) else {
                    continue
                }
                timeStreamImageStrips[nodeType] = timeStreamImageStrip
            }
            return timeStreamImageStrips
        }
        
        public static func generateStrip(planetNodeStates: [PlanetNodeState],
                                         nodeType: CoreAstrology.AspectBody.NodeType,
                                  colorRenderMode: TimeStream.ColorRenderMode,
                                  dataMetric: TimeStream.DataMetric) -> TimeStream.ImageStrip? {
            print("generating ImageStrips [\(planetNodeStates.count)]")
            let width = planetNodeStates.count
            let height = 1
            
            var rgbaArray:[RGBAColor] = planetNodeStates.map { return colorRenderMode.renderColor(dataMetric: dataMetric, planetNodeState: $0) }
            let bitmapCount: Int = rgbaArray.count
            let elmentLength: Int = 4 // Bytes
            let render: CGColorRenderingIntent = .defaultIntent//CGColorRenderingIntent.RenderingIntentDefault
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            
            guard let providerRef: CGDataProvider = CGDataProvider(data: NSData(bytes: &rgbaArray, length: bitmapCount * elmentLength)) else {
                print("ERROR: CGDataProvider could not be generated")
                return nil
            }
            
            
            guard let cgImage: CGImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * elmentLength, space: rgbColorSpace, bitmapInfo: bitmapInfo, provider: providerRef, decode: nil, shouldInterpolate: true, intent: render) else {
                print("ERROR: CGImage could not be generated")
                return nil
            }
            
            return TimeStream.ImageStrip(uiImage: UIImage(cgImage: cgImage),
                                         nodeType: nodeType,
                                         colorRenderMode: colorRenderMode)

            
        }
    }

}
