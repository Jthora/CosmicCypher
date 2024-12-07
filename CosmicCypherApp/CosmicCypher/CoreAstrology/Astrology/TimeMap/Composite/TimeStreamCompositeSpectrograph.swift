//
//  TimeStreamCompositeSpectrograph.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/24/23.
//

import Foundation
import Metal
import MetalKit

extension TimeStream.Composite {
    class Spectrograph {
        // Metal Renderer for Spectrograph
        private var renderer: MetalRenderer

        // Configuration Data
        private var configuration: TimeStream.Configuration

        // Current Spectrogram Data
        private var spectrogramData: SpectrogramData?

        // Initialization
        init(renderer: MetalRenderer, configuration: TimeStream.Configuration) {
            self.renderer = renderer
            self.configuration = configuration
        }

        // Update Spectrograph with New Date
        func updateSpectrograph(for date: Date) {
            // Generate SpectrogramData for the given date
            spectrogramData = generateSpectrogramData(for: date)

            guard let spectrogramData = spectrogramData else {
                print("Failed to generate SpectrogramData for date: \(date)")
                return
            }

            // Update renderer with new SpectrogramData
            renderer.updateSpectrographData(spectrogramData)
            print("Spectrograph updated for date: \(date)")
        }

        private func generateSpectrogramData(for date: Date) -> SpectrogramData? {
            // Example logic for generating spectrogram data
            let numberOfFrequencies = 50
            let frequencies = (0..<numberOfFrequencies).map { Float($0) * 10 }  // Example frequencies (e.g., Hz)
            let amplitudes = frequencies.map { sin(($0) * Float(date.timeIntervalSince1970.truncatingRemainder(dividingBy: 1))) }  // Example amplitudes
            let timeSlices = (0..<numberOfFrequencies).map { date.addingTimeInterval(Double($0)) }  // Example time intervals

            return SpectrogramData(frequencies: frequencies, amplitudes: amplitudes, timeSlices: timeSlices)
        }
    }
}

struct SpectrogramData {
    let frequencies: [Float]     // Array of frequency values
    let amplitudes: [Float]      // Corresponding amplitudes for each frequency
    let timeSlices: [Date]       // Time slices for the Spectrograph
}
