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
        // data?
        init(frame: CGRect,configuration: TimeStream.Configuration, chartMode:ChartMode = .gravimetrics, onComplete:(()->())? = nil) {
            self.configuration = configuration
            super.init(frame: frame)
            
            self.setScaleEnabled(true)
            
            setupChartData(chartMode: chartMode, onComplete:onComplete)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupChartData(chartMode:ChartMode, 
                            onProgress:((_ completion:Double)->Void)? = nil,
                            onComplete:(()->())? = nil) {
            let nodeTypes = configuration.nodeTypes
            
            switch chartMode {
            case .gravimetrics:
                setGravimeticData(nodeTypes: nodeTypes, onProgress: onProgress, onComplete: onComplete)
            case .exaDeb:
                setExaDebData(nodeTypes: nodeTypes, onProgress: onProgress, onComplete: onComplete)
            case .riseFall:
                setRiseFallData(nodeTypes: nodeTypes, onProgress: onProgress, onComplete: onComplete)
            }
        }
        
        func setGravimeticData(nodeTypes: [AstrologicalNodeType],
                               onProgress:((_ completion:Double)->Void)? = nil,
                               onComplete:(()->())? = nil) {
            
            guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
            var globalNetGravityEntries: [ChartDataEntry] = []
            var stellarNetGravityEntries: [ChartDataEntry] = []
            var interplanetaryNetGravityEntries: [ChartDataEntry] = []
            
            var totalIterations:Double = 300.0
            var currentIteration:Double = 0.0
            onProgress?(0)
            
            dataAccessQueue.async {
                guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
                //guard let resonanceScores = self.timeStreamComposite?.resonanceScores else { return }
                //let globalNetEnergies = resonanceScores.map({ $0.energies.globalNetEnergy })
                
                let globalNetGravimetricMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                }
                
                let stellarNetGravimentricMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                }
            }
            
            dataAccessQueue.sync {
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
        
        func setExaDebData(nodeTypes: [AstrologicalNodeType],
                           onProgress:((_ completion:Double)->Void)? = nil,
                           onComplete:(()->())? = nil) {
            guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
            var globalNetGravityEntries: [ChartDataEntry] = []
            var stellarNetGravityEntries: [ChartDataEntry] = []
            var interplanetaryNetGravityEntries: [ChartDataEntry] = []
            
            var totalIterations:Double = 300.0
            var currentIteration:Double = 0.0
            onProgress?(0)
            
            dataAccessQueue.async {
                let globalNetGravimetricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                }
                
                let stellarNetGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                    currentIteration += 1
                    onProgress?(currentIteration / totalIterations)
                }
            }
            
            dataAccessQueue.sync {
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
        
        func setRiseFallData(nodeTypes: [AstrologicalNodeType], 
                             onProgress:((_ completion:Double)->Void)? = nil,
                             onComplete:(()->())? = nil) {
            guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
            var globalNetGravityEntries: [ChartDataEntry] = []
            var stellarNetGravityEntries: [ChartDataEntry] = []
            var interplanetaryNetGravityEntries: [ChartDataEntry] = []
            
            var totalIterations:Double = 300.0
            var currentIteration:Double = 0.0
            onProgress?(0)
            
            dataAccessQueue.async {
                
                let globalNetGravimetricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                }
                
                let stellarNetGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                }
            }
            
            dataAccessQueue.sync {
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
