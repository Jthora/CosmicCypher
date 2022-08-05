//
//  ResonanceReportViewController+UpdateOperation.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 8/5/22.
//

import Foundation

extension ResonanceReportViewController {
    // Update Operation
    class ResonanceReportUpdateOperation: Operation {
        
        var vc: ResonanceReportViewController
        init(_ vc:ResonanceReportViewController) {
            self.vc = vc
        }
        
        // Run Update Operation Function
        override func main() {

            // Update on Main Thread
            if isCancelled { return }
            DispatchQueue.main.async {

                /// Current StarChart and Details
                let starChart = StarChart.Core.current
                let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)

                /// Text Fields
                self.vc.dateTimeCoordsLabel.text = "Latitude: \(starChart.coordinates.latitude)\nLongitude: \(-starChart.coordinates.longitude)\nDate: \(starChart.date.formatted(date: .numeric, time: .omitted))\nTime: \(starChart.date.formattedTime(for: starChart.coordinates))"
                self.vc.aspectsResultsTableView.reloadData()

                /// Energy Levels
                self.vc.updateEnergyLevels(starChart:starChart)

                /// Modality Meters
                self.vc.updateModalityMeters(starChart:starChart)

                /// Discernment Chart
                if self.isCancelled { return }
                self.vc._updateQueue.async {

                    /// Central Point
                    DispatchQueue.main.async {
                        if self.isCancelled { return }
                        guard let cp = self.vc.createDiscernmentCentralPoint() else {return}
                        if self.isCancelled { return }
                        self.vc.discernmentCentralPoint?.removeFromSuperlayer()
                        self.vc.discernmentCentralPoint = nil
                        self.vc.discernmentCentralPoint = cp
                        self.vc.discernmentGraphView.layer.addSublayer(self.vc.discernmentCentralPoint!)
                    }

                    /// Central Circle
                    DispatchQueue.main.async {
                        guard let dcb = self.vc.createDiscernmentCentralGraphZone() else {return}
                        if self.isCancelled { return }
                        self.vc.discernmentCentralBlob?.removeFromSuperlayer()
                        self.vc.discernmentCentralBlob = nil
                        self.vc.discernmentCentralBlob = dcb
                        self.vc.discernmentGraphView.layer.addSublayer(self.vc.discernmentCentralBlob!)
                    }

                    /// Outer Circle
                    DispatchQueue.main.async {
                        if self.isCancelled { return }
                        guard let dob = self.vc.createDiscernmentOuterGraphZone() else {return}
                        if self.isCancelled { return }
                        self.vc.discernmentOuterBlob?.removeFromSuperlayer()
                        self.vc.discernmentOuterBlob = nil
                        self.vc.discernmentOuterBlob = dob
                        self.vc.discernmentGraphView.layer.addSublayer(self.vc.discernmentOuterBlob!)
                    }


                }

            }
        }
    }
}
