//
//  TimeStreamChartTableViewCell.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/2/22.
//

import UIKit
import Charts
import TinyConstraints

class TimeStreamChartTableViewCell: UITableViewCell {
    
    var lineChartView: LineChartView = {
       let lineChartView = LineChartView()
        lineChartView.backgroundColor = .systemBlue
        return lineChartView
    }()
    
    var chart: TimeStream.Chart? = nil
    
    // Reload Cell View
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupCosmicEventSpriteNodes()
        
        
        setup()
    }
    
    func setup() {
        // setup view
        self.contentView.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: self.contentView)
        lineChartView.height(to: self.contentView)
    }
    
    func update() {
        // use chart to populate data
        setData()
    }
    
    func setData() {
        let entries: [ChartDataEntry] = []
        let set1 = LineChartDataSet(entries: entries, label: "Gravimetrics")
        let data = LineChartData(dataSets: [set1])
        lineChartView.data = data
    }
}
