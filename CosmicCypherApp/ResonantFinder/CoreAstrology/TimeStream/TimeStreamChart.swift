//
//  TimeStreamChart.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/2/22.
//

import UIKit
import Charts

extension TimeStream {
    class Chart: LineChartView {
        
        let configuration: TimeStream.Configuration
        // data?
        init(configuration: TimeStream.Configuration) {
            self.configuration = configuration
            super.init()
            
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func setup() {
            
        }
    }
}
