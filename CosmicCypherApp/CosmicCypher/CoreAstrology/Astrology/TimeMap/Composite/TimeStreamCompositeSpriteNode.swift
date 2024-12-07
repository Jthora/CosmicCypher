//
//  TimeStreamCompositeSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/3/22.
//

import Foundation
import SpriteKit

public typealias TimeStreamCompositeSpriteNode = TimeStream.Composite.SpriteNode
extension TimeStream.Composite {
    public class SpriteNode: SKSpriteNode {
        
        // MARK: Static
        // Default Configuration
        static let defaultConfiguration = TimeStream.Configuration(
            sampleCount: 100,
            primaryChart: nil,
            secondaryChart: nil,
            timeStreams: [],
            nodeTypes: []
        )
        
        // MARK: Properties
        var composite:TimeStream.Composite
        var timeStreamSpriteNodes:[TimeStreamSpriteNode] = []
        
        var currentNotch: TimeStreamCompositeNotchSpriteNode? = nil
        var notchSprites:[TimeStreamCompositeNotchSpriteNode] = []
        
        // Scrubber Sprite
        var scrubberSprite: SKSpriteNode = {
            let sprite = SKSpriteNode(imageNamed: "scrubber_indicator.png")
            sprite.size = CGSize(width: 16, height: 32)
            sprite.alpha = 0.75
            sprite.position = .zero
            return sprite
        }()
        
        // Throttling Variables
        private var lastUpdateTimestamp: TimeInterval = 0
        private let renderThrottleInterval: TimeInterval = 0.1 // 10 renders per second
        
        // Timeline Information
        var timelineStartDate: Date = Date(timeIntervalSince1970: 0) // Default to epoch
        var timelineEndDate: Date = Date() // Default to now
        
        func closestNotch() -> TimeStreamCompositeNotchSpriteNode? {
            var distanceArray = [Int]()
            var closestNode : TimeStreamCompositeNotchSpriteNode?
            for node in notchSprites {
                if let sprite = node as? TimeStreamCompositeNotchSpriteNode {
                    let distance = Int(sprite.position.y)
                    distanceArray.append(distance)
                    if distance == distanceArray.min() {
                        closestNode = sprite
                    }
                }
            }
            return closestNode
        }
        
        // MARK: Init
        // Custom Initializer
        public init(size: CGSize) {
            self.composite = TimeStream.Composite(name: "default", uuid: UUID(), configuration: TimeStreamCompositeSpriteNode.defaultConfiguration)
            super.init(texture: nil, color: .clear, size: size)
            self.setupNode()
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.composite = TimeStream.Composite(name: "default", uuid: UUID(), configuration: TimeStreamCompositeSpriteNode.defaultConfiguration)
            super.init(coder: aDecoder)
            self.setupNode()
        }
        
        init(timeStreamComposite:TimeStream.Composite, size: CGSize) {
            self.composite = timeStreamComposite
            super.init(texture: nil, color: .black, size: size)
            setup()
        }
        
        // MARK: Setup
        func setup() {
            self.removeAllChildren()
            addTimeStreams()
            addPlanets()
            addNotches()
            addScrubber()
        }
        
        func addTimeStreams() {
            guard let imageMap = composite.imageMap else {
                print("addTimeStreams failed: no image map yet")
                return
            }
            
            guard !imageMap.imageStripSets.isEmpty else {
                print("addTimeStreams failed: no imageStripSets yet")
                return
            }
            
            // create Sub-Sprites for Image Strips
            for imageStripSet in imageMap.imageStripSets {
                let timeStreamSpriteNode = TimeStreamSpriteNode(size: size, imageStripSet: imageStripSet)
                timeStreamSpriteNodes.append(timeStreamSpriteNode)
                self.addChild(timeStreamSpriteNode)
            }
        }
        
        func addPlanets() {
            for timeStreamSpriteNode in timeStreamSpriteNodes {
                for (planet,spriteNode) in timeStreamSpriteNode.spriteNodes {
                    
                    // Add Planet Image Icon
                    let planetTexture = SKTexture(imageNamed: planet.imageName)
                    let size = CGSize(width: spriteNode.size.height/2, height: spriteNode.size.height)
                    let planetImageSpriteNode = SKSpriteNode(texture: planetTexture, color: .clear, size: size)
                    let x = (-self.size.width/2) + (spriteNode.size.height/4)
                    let y = spriteNode.position.y
                    planetImageSpriteNode.position = CGPoint(x: x, y: y)
                    addChild(planetImageSpriteNode)
                }
            }
        }
        
        func addNotches() {
            let timestream = composite.configuration.timeStreams.first!
            let upperBound = timestream.dateRange.upperBound
            let lowerBound = timestream.dateRange.lowerBound
            let count = timestream.starCharts.count
            
            let maxTimeInterval = upperBound.timeIntervalSince1970
            let minTimeInterval = lowerBound.timeIntervalSince1970
            let totalTime = maxTimeInterval - minTimeInterval
            let timeStep = totalTime/Double(count)
            
            for starChart in timestream.starCharts {
                let starChartTimeInterval = starChart.date.timeIntervalSince1970
                let offsetInterval = starChartTimeInterval - minTimeInterval
                let normalizedInterval = offsetInterval/totalTime
                let width = self.size.width
                let x = CGFloat(width * normalizedInterval)
                
                let height = self.size.height/10
                let size = CGSize(width: 0.5, height: height)
                let position = CGPoint(x: x-(self.size.width/2), y: -self.size.height/2)
                let point = starChart.timeStreamPoint
                let notchSprite = TimeStreamCompositeNotchSpriteNode(point: point, size: size)
                
                notchSprite.position = position
                self.addChild(notchSprite)
                notchSprites.append(notchSprite)
            }
            
            
            // starcharts
            // dates
            // timeintervals
            // normalized
            // x position from scene.size.width
            
        }
        
        func addScrubber() {
            scrubberSprite.size = CGSize(width: 16, height: self.size.height + 32)
            scrubberSprite.alpha = 0.75
            scrubberSprite.position = .zero
            addChild(scrubberSprite)
            setScrubber(x: scrubberSprite.position.x)
        }
        
        
        
        private func setupNode() {
            // Initialize scrubber sprite or other properties
            let scrubberSprite = SKSpriteNode(imageNamed: "scrubber_indicator.png")
            scrubberSprite.size = CGSize(width: 16, height: 32)
            scrubberSprite.alpha = 0.75
            scrubberSprite.position = .zero
            self.addChild(scrubberSprite)
        }
        
        func scrubberCloseTo(x:CGFloat, range:CGFloat = 3) -> Bool {
            let pos = scrubberSprite.position
            let size = scrubberSprite.size
            let xmin = x > pos.x - (size.width*range)
            let xmax = x < pos.x + (size.width*range)
            
            return  xmin && xmax
        }
        
        // Scrubber Position Update
        func setScrubber(x: CGFloat, updateStarChart: Bool = true) {
            // Ensure the scrubber position stays within bounds
            scrubberSprite.position.x = max(0, min(x, self.size.width))
            
            if updateStarChart {
                // Throttle StarChart updates
                let currentTime = CACurrentMediaTime()
                if currentTime - lastUpdateTimestamp >= renderThrottleInterval {
                    lastUpdateTimestamp = currentTime
                    
                    // Convert scrubber position to a date
                    let scrubberDate = dateFromPosition(x)
                    applyStarChartUpdate(date: scrubberDate)
                }
            }
        }
        
        // Convert Scrubber Position to Timeline Date
        private func dateFromPosition(_ x: CGFloat) -> Date {
            let timelineWidth = self.size.width
            let normalizedPosition = x / timelineWidth
            let timelineDuration = timelineEndDate.timeIntervalSince(timelineStartDate)
            let timeOffset = normalizedPosition * timelineDuration
            return timelineStartDate.addingTimeInterval(timeOffset)
        }
        
        // Update the StarChart Based on Date
        private func applyStarChartUpdate(date: Date) {
            if let starChart = try? StarChartRegistry.main.getStarChart(date: date, geographicCoordinates: StarChart.Core.current.coordinates) {
                StarChart.Core.current = starChart
                ResonanceReportViewController.current?.update()
            } else {
                print("StarChart not available for date: \(date)")
            }
        }
        
        func getTimeStreamPoint(for position:CGPoint? = nil) -> TimeStream.Point? {
            if let position = position {
                return getClosestNotch(for: position)?.point
            } else {
                return getClosestNotch(for: scrubberSprite.position)?.point
            }
        }
        
        func getCurrentlyClosestNotch() -> TimeStreamCompositeNotchSpriteNode? {
            return getClosestNotch(for: scrubberSprite.position)
        }
        
        func getMiddleNotch() -> TimeStreamCompositeNotchSpriteNode? {
            guard !notchSprites.isEmpty else { return nil }
            let index = Int(notchSprites.count/2)
            return notchSprites[index]
        }
        
        func getClosestNotch(for position:CGPoint) -> TimeStreamCompositeNotchSpriteNode? {
            var distanceArray = [CGFloat]()
            var closestNotch:TimeStreamCompositeNotchSpriteNode? = nil
            for notch in notchSprites {
                let distance = notch.position.distance(to: position)
                distanceArray.append(distance)

                if let currentMin = distanceArray.min(), distance <= currentMin {
                    closestNotch = notch
                }
            }
            
            if let returnNotch = closestNotch {
                return returnNotch
            } else if let returnNotch = getMiddleNotch() {
                return returnNotch
            } else {
                return notchSprites.first
            }
        }
        
        func setScrubber(position:CGPoint, animateToNotch: Bool = true) {
            if animateToNotch,
               let closestNotch = getClosestNotch(for: position) {
                let newPosition = CGPoint(x: closestNotch.position.x, y: scrubberSprite.position.y)
                let action = SKAction.move(to: newPosition, duration: 0.1)
                scrubberSprite.run(action)
                currentNotch = closestNotch
            } else if let closestNotch = getClosestNotch(for: position) {
                let newPosition = CGPoint(x: closestNotch.position.x, y: scrubberSprite.position.y)
                scrubberSprite.position = newPosition
            } else {
                scrubberSprite.position = position
            }
        }
    }
}

