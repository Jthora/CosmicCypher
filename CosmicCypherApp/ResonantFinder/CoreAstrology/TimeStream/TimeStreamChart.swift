//
//  TimeStreamChart.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/2/22.
//

import UIKit
import Charts

extension TimeStream {
    class Chart: LineChartView {
        let dataAccessQueue = DispatchQueue(label: "app.cosmiccypher.dataAccessQueue")
        
        enum ChartMode {
            case gravimetrics
            case exaDeb
            case riseFall
        }
        
        let configuration: TimeStream.Configuration
        
        init(frame: CGRect,configuration: TimeStream.Configuration,
             onProgress:((_ completion:Float)->Void)? = nil,
             chartMode:ChartMode = .gravimetrics,
             onComplete:(()->())? = nil) {
            self.configuration = configuration
            super.init(frame: frame)
            
            self.setScaleEnabled(true)
            
            setupChartData(chartMode: chartMode, onProgress: onProgress, onComplete:onComplete)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupChartData(chartMode:ChartMode, 
                            onProgress:((_ completion:Float)->Void)? = nil,
                            onComplete:(()->())? = nil) {
            let nodeTypes = configuration.nodeTypes
            
            let startDate = Date()
            
            switch chartMode {
            case .gravimetrics:
                setGravimeticData(nodeTypes: nodeTypes, onProgress: onProgress, onComplete: onComplete)
            case .exaDeb:
                setExaDebData(nodeTypes: nodeTypes, onProgress: onProgress, onComplete: onComplete)
            case .riseFall:
                setRiseFallData(nodeTypes: nodeTypes, onProgress: onProgress, onComplete: onComplete)
            }
            
            print("TimeStream Chart Delta: \(startDate.timeIntervalSinceNow)")
        }
        
        func setGravimeticData(nodeTypes: [PlanetNodeType],
                               onProgress:((_ completion:Float)->Void)? = nil,
                               onComplete:(()->())? = nil) {
            dataAccessQueue.async {
                
                let startDate = Date()
                
                guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
                var globalNetGravityEntries: [ChartDataEntry] = []
                var stellarNetGravityEntries: [ChartDataEntry] = []
                var interplanetaryNetGravityEntries: [ChartDataEntry] = []
                
                let totalIterations:Float = 300.0
                var currentIteration:Float = 0.0
                onProgress?(0)
                
                // Global (Geocentric)
                var globalNetGravimetricMagnitudes:[Double] = []
                for chart in starCharts {
                    /// Calculate
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                    let magnitude = chart.globalNetGravimetricMagnitude(includeSun: false)
                    globalNetGravimetricMagnitudes.append(magnitude)
                }
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    /// Convert
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                }
                
                // Stellar (Heliocentric)
                var stellarNetGravimentricMagnitudes:[Double] = []
                for chart in starCharts {
                    /// Calculate
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                    let magnitude = chart.stellarNetGravimentricMagnitude()
                    stellarNetGravimentricMagnitudes.append(magnitude)
                }
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    /// Convert
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                }
                
                // Unified (Interplanetary)
                var interplanetaryAbsoluteGravimentricMagnitudes:[Double] = []
                for chart in starCharts {
                    /// Calculate
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                    let magnitude = chart.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true)
                    interplanetaryAbsoluteGravimentricMagnitudes.append(magnitude)
                }
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    /// Convert
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                }
                
                // Completed
                onProgress?(1)
                let set1 = LineChartDataSet(entries: globalNetGravityEntries, label: "global")
                set1.colors = [.systemMint]
                set1.circleColors = [.systemMint]
                set1.circleRadius = 3
                let set2 = LineChartDataSet(entries: stellarNetGravityEntries, label: "stellar")
                set2.colors = [.systemYellow]
                set2.circleColors = [.systemYellow]
                set2.circleRadius = 3
                let set3 = LineChartDataSet(entries: interplanetaryNetGravityEntries, label: "interplanetary")
                set3.colors = [.systemIndigo]
                set3.circleColors = [.systemIndigo]
                set3.circleRadius = 3
                
                DispatchQueue.main.async {
                    let data = LineChartData(dataSets: [set1,set2,set3])
                    self.data = data
                    onComplete?()
                }
            }
            
        }
        
        func setExaDebData(nodeTypes: [PlanetNodeType],
                           onProgress:((_ completion:Float)->Void)? = nil,
                           onComplete:(()->())? = nil) {
            guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
            var globalNetGravityEntries: [ChartDataEntry] = []
            var stellarNetGravityEntries: [ChartDataEntry] = []
            var interplanetaryNetGravityEntries: [ChartDataEntry] = []
            
            let totalIterations:Float = 300.0
            var currentIteration:Float = 0.0
            
            DispatchQueue.main.async {
                onProgress?(0)
            }
            
            dataAccessQueue.async {
                DispatchQueue.main.async {
                    onProgress?(0)
                }
                
                // Global (Geocentric)
                var globalNetGravimetricMagnitudes: EnergyMagnitudes = []
                for chart in starCharts {
                    /// Calculate
                    let magnitude = chart.globalNetGravimetricMagnitude(includeSun: false)
                    globalNetGravimetricMagnitudes.append(magnitude)
                }
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    /// Convert
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                    /// Iterate
                    currentIteration += 1
                    DispatchQueue.main.async {
                        onProgress?(currentIteration / totalIterations)
                    }
                }
                
                // Stellar (Heliocentric)
                var stellarNetGravimentricMagnitudes: EnergyMagnitudes = []
                for chart in starCharts {
                    /// Calculate
                    let magnitude = chart.stellarNetGravimentricMagnitude()
                    stellarNetGravimentricMagnitudes.append(magnitude)
                }
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    /// Convert
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                    /// Iterate
                    currentIteration += 1
                    DispatchQueue.main.async {
                        onProgress?(currentIteration / totalIterations)
                    }
                }
                
                // Unified (Interplanetary)
                var interplanetaryAbsoluteGravimentricMagnitudes: EnergyMagnitudes = []
                for chart in starCharts {
                    /// Calculate
                    let magnitude = chart.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true)
                    interplanetaryAbsoluteGravimentricMagnitudes.append(magnitude)
                }
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    /// Convert
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                    /// Iterate
                    currentIteration += 1
                    DispatchQueue.main.async {
                        onProgress?(currentIteration / totalIterations)
                    }
                }
            }
            
            dataAccessQueue.sync {
                DispatchQueue.main.async {
                    onProgress?(1)
                }
                let set1 = LineChartDataSet(entries: globalNetGravityEntries, label: "global")
                set1.colors = [.systemMint]
                set1.circleColors = [.systemMint]
                set1.circleRadius = 3
                let set2 = LineChartDataSet(entries: stellarNetGravityEntries, label: "stellar")
                set2.colors = [.systemYellow]
                set2.circleColors = [.systemYellow]
                set2.circleRadius = 3
                let set3 = LineChartDataSet(entries: interplanetaryNetGravityEntries, label: "interplanetary")
                set3.colors = [.systemIndigo]
                set3.circleColors = [.systemIndigo]
                set3.circleRadius = 3
                
                DispatchQueue.main.async {
                    let data = LineChartData(dataSets: [set1,set2,set3])
                    self.data = data
                    onComplete?()
                }
            }
        }
        
        func setRiseFallData(nodeTypes: [PlanetNodeType], 
                             onProgress:((_ completion:Float)->Void)? = nil,
                             onComplete:(()->())? = nil) {
            guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
            var globalNetGravityEntries: [ChartDataEntry] = []
            var stellarNetGravityEntries: [ChartDataEntry] = []
            var interplanetaryNetGravityEntries: [ChartDataEntry] = []
            
            let totalIterations:Float = 300.0
            var currentIteration:Float = 0.0
            
            DispatchQueue.main.async {
                onProgress?(0)
            }
            
            dataAccessQueue.async {
                
                let globalNetGravimetricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                    
                    // Iter
                    currentIteration += 1
                    DispatchQueue.main.async {
                        onProgress?(currentIteration / totalIterations)
                    }
                }
                
                let stellarNetGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                    
                    // Iter
                    currentIteration += 1
                    DispatchQueue.main.async {
                        onProgress?(currentIteration / totalIterations)
                    }
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                    
                    // Iter
                    currentIteration += 1
                    DispatchQueue.main.async {
                        onProgress?(currentIteration / totalIterations)
                    }
                }
            }
            
            dataAccessQueue.sync {
                DispatchQueue.main.async {
                    onProgress?(1)
                }
                let set1 = LineChartDataSet(entries: globalNetGravityEntries, label: "global")
                set1.colors = [.systemMint]
                set1.circleColors = [.systemMint]
                set1.circleRadius = 3
                let set2 = LineChartDataSet(entries: stellarNetGravityEntries, label: "stellar")
                set2.colors = [.systemYellow]
                set2.circleColors = [.systemYellow]
                set2.circleRadius = 3
                let set3 = LineChartDataSet(entries: interplanetaryNetGravityEntries, label: "interplanetary")
                set3.colors = [.systemIndigo]
                set3.circleColors = [.systemIndigo]
                set3.circleRadius = 3
                
                DispatchQueue.main.async {
                    let data = LineChartData(dataSets: [set1,set2,set3])
                    self.data = data
                    onComplete?()
                }
            }
        }
    }
}
