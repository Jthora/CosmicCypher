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
            
            setupChartData(chartMode: chartMode, onComplete:onComplete)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupChartData(chartMode:ChartMode, onComplete:(()->())? = nil) {
            let nodeTypes = configuration.nodeTypes
            
            switch chartMode {
            case .gravimetrics:
                setGravimeticData(nodeTypes: nodeTypes, onComplete: onComplete)
            case .exaDeb:
                setExaDebData(nodeTypes: nodeTypes, onComplete: onComplete)
            case .riseFall:
                setRiseFallData(nodeTypes: nodeTypes, onComplete: onComplete)
            }
        }
        
        func setGravimeticData(nodeTypes: [AstrologicalNodeType], onComplete:(()->())? = nil) {
            Task {
                guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
                //guard let resonanceScores = self.timeStreamComposite?.resonanceScores else { return }
                //let globalNetEnergies = resonanceScores.map({ $0.energies.globalNetEnergy })
                
                
                let globalNetGravimetricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                var globalNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                }
                
                let stellarNetGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                var stellarNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                var interplanetaryNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                }
                
                DispatchQueue.main.async {
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
                    let data = LineChartData(dataSets: [set1,set2,set3])
                    self.data = data
                    
                    onComplete?()
                }
            }
        }
        
        func setExaDebData(nodeTypes: [AstrologicalNodeType], onComplete:(()->())? = nil) {
            Task {
                guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
                //guard let resonanceScores = self.timeStreamComposite?.resonanceScores else { return }
                //let globalNetEnergies = resonanceScores.map({ $0.energies.globalNetEnergy })
                
                
                let globalNetGravimetricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                var globalNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                }
                
                let stellarNetGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                var stellarNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                var interplanetaryNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                }
                
                DispatchQueue.main.async {
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
                    let data = LineChartData(dataSets: [set1,set2,set3])
                    self.data = data
                    
                    onComplete?()
                }
            }
        }
        
        func setRiseFallData(nodeTypes: [AstrologicalNodeType], onComplete:(()->())? = nil) {
            Task {
                guard let starCharts = self.configuration.timeStreams.first?.starCharts else { return }
                //guard let resonanceScores = self.timeStreamComposite?.resonanceScores else { return }
                //let globalNetEnergies = resonanceScores.map({ $0.energies.globalNetEnergy })
                
                
                
                
                let globalNetGravimetricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.globalNetGravimetricMagnitude(includeSun: false) })
                
                let nodeStates = starCharts.map({ $0.astrologicalNodeStates() })
                let nodeState = nodeStates
                
                
                var globalNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in globalNetGravimetricMagnitudes.enumerated() {
                    let normalizedMagnitude = globalNetGravimetricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    globalNetGravityEntries.append(entry)
                }
                
                let stellarNetGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.stellarNetGravimentricMagnitude() })
                var stellarNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in stellarNetGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = stellarNetGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    stellarNetGravityEntries.append(entry)
                }
                
                let interplanetaryAbsoluteGravimentricMagnitudes:EnergyMagnitudes = starCharts.map({ $0.interplanetaryAbsoluteGravimentricMagnitude(includeSun: true) })
                var interplanetaryNetGravityEntries: [ChartDataEntry] = []
                for (i,magnitude) in interplanetaryAbsoluteGravimentricMagnitudes.enumerated() {
                    let normalizedMagnitude = interplanetaryAbsoluteGravimentricMagnitudes.normalize(magnitude: magnitude)!
                    let entry = ChartDataEntry(x: Double(i), y: Double(normalizedMagnitude))
                    interplanetaryNetGravityEntries.append(entry)
                }
                
                DispatchQueue.main.async {
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
                    let data = LineChartData(dataSets: [set1,set2,set3])
                    self.data = data
                    
                    onComplete?()
                }
            }
        }
    }
}
