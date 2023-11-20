//
//  PlanetNodeCollectionViewCell.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation

import UIKit

class PlanetNodeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Context
    var selectionContext:PlanetNodesAndAspectsViewController.SelectionContext = .starChart
    
    
    // MARK: Outlets
    // Image Views
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var topZodiacImageView: UIImageView!
    @IBOutlet weak var topElementImageView: UIImageView!
    @IBOutlet weak var topModalityImageView: UIImageView!
    @IBOutlet weak var bottomZodiacImageView: UIImageView!
    @IBOutlet weak var bottomElementImageView: UIImageView!
    @IBOutlet weak var bottomModalityImageView: UIImageView!
    
    //Text Views
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var planetDescriptionTextView: UITextView!
    @IBOutlet weak var astronomyTextView: UITextView!
    @IBOutlet weak var metricsTextView: UITextView!
    
    // Labels
    @IBOutlet weak var planetLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topPercentLabel: UILabel!
    @IBOutlet weak var bottomPercentLabel: UILabel!
    @IBOutlet weak var topModalityLabel: UILabel!
    @IBOutlet weak var topElementLabel: UILabel!
    @IBOutlet weak var bottomModalityLabel: UILabel!
    @IBOutlet weak var bottomElementLabel: UILabel!
    
    
    // MARK: Properties
    // is Selected
    override var isSelected: Bool {
        didSet {
            if isSelected {
                planetSelected = !planetSelected
            }
        }
    }
    
    // Planet
    var planet:CoreAstrology.AspectBody.NodeType? = nil {
        didSet {
            update()
        }
    }
    
    // Alignment
    var planetNode:PlanetNode? {
        guard let planet = planet else {return nil}
        return  StarChart.Core.current.planetNodes[planet]
    }
    
    // Planet Selected
    var planetSelected:Bool = true {
        didSet {
            updateCore()
            animatePlanetSelected()
        }
    }
    
    // MARK: View Life Cycle
    // Load from Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // Setup
    func setup() {
        setSelectedState(selected:planetSelected)
    }
    
    // MARK: Update
    // Update
    func update() {
        updatePlanetNodeDetails()
        updateTopAndBottomDetails()
        updateAstronomyDetails()
    }
    
    // Update Planet Node Content
    func updatePlanetNodeDetails() {
        guard let planet = planet else {
            planetImageView.image = nil
            planetLabel.text = ""
            return
        }
        planetImageView.image = planet.image
        planetLabel.text = planet.text
        switch selectionContext {
        case .starChart:
            planetSelected = StarChart.Core.selectedNodeTypes.contains(planet)
        case .aspectScanner:
            planetSelected = AspectEventScanner.Core.planetsAndNodes.contains(planet)
        }
        
        guard let planetNode = planetNode,
              let alpha = planetNode.coordinates?.alpha,
              let delta = planetNode.coordinates?.delta,
              let declination = planetNode.coordinates?.declination,
              let distance = planetNode.distance,
              let geocentricGravity = planetNode.nodeType.gravimetricForceOnEarth(date: planetNode.date),
              let heliocentricGravity = planetNode.nodeType.gravimetricForceOnSun(date: planetNode.date),
              let mass = planetNode.mass else {return}
        
        astronomyTextView.text = "🔭Astronomy:\n\nAlpha:\n[\(alpha)]\n\nDelta:\n[\(delta)]\n\nDeclination:\n[\(declination)]"
        metricsTextView.text = "📊Metrics:\n\nDistance:\n[\(distance)]\n\nMass:\n[\(mass)]\n\nGravity:\n♁[\(geocentricGravity)]\n☉[\(heliocentricGravity)]"
    }
    
    // Update Zodiac Content
    func updateTopAndBottomDetails() {
        guard let planet = planet,
              let chevron = planetNode?.createChevron() else {
            topZodiacImageView.image = nil
            bottomZodiacImageView.image = nil
            topLabel.text = ""
            bottomLabel.text = ""
            return
        }
        topZodiacImageView.image = chevron.topZodiac.image
        bottomZodiacImageView.image = chevron.bottomZodiac.image
        topElementImageView.image = chevron.topZodiac.element.uiImage
        topModalityImageView.image = chevron.topZodiac.modality.uiImage
        bottomElementImageView.image = chevron.bottomZodiac.element.uiImage
        bottomModalityImageView.image = chevron.bottomZodiac.modality.uiImage
        
        topPercentLabel.text = "\(Int((chevron.topZodiacDistribution*100).rounded(.toNearestOrEven)))%"
        bottomPercentLabel.text = "\(Int((chevron.bottomZodiacDistribution*100).rounded(.toNearestOrEven)))%"
        
        topLabel.text = "\(chevron.topZodiac.text)"
        topModalityLabel.text = chevron.topZodiac.modality.text
        topElementLabel.text = chevron.topZodiac.element.text
        bottomLabel.text = "\(chevron.bottomZodiac.text)"
        bottomModalityLabel.text = chevron.bottomZodiac.modality.text
        bottomElementLabel.text = chevron.bottomZodiac.element.text
        
        topTextView.text = "\(chevron.topZodiac.emoji)\(chevron.topZodiac.text):\n\(chevron.topZodiac.chineseWordFull)\(chevron.topZodiac.chineseEmoji)\n\n\(chevron.topZodiac.subtitle)\n\n\(chevron.topZodiac.modality.text)\n\(chevron.topZodiac.modality.altText)\n\n\(chevron.topZodiac.combinedKeywords)\n\n\(chevron.topZodiac.description)\n\n\(chevron.bottomZodiac.details)"
        bottomTextView.text = "\(chevron.bottomZodiac.emoji)\(chevron.bottomZodiac.text):\n\(chevron.bottomZodiac.chineseWordFull)\(chevron.bottomZodiac.chineseEmoji)\n\n\(chevron.bottomZodiac.subtitle)\n\n\(chevron.bottomZodiac.modality.text)\n\(chevron.bottomZodiac.modality.altText)\n\n\(chevron.bottomZodiac.combinedKeywords)\n\n\(chevron.bottomZodiac.description)\n\n\(chevron.bottomZodiac.details)"
    }
    
    // Update
    func updateAstronomyDetails() {
        guard let planet = planet else {
            planetImageView.image = nil
            planetLabel.text = ""
            return
        }
        
        let planetDescripton:String = "\(planet.symbol)\(planet.text):\n\n\(planet.subtitle)\n\n\(planet.attributesCombined)\n\n\(planet.shortDescription)\n\n\(planet.description)\n\n\(planet.description)\n\n\(planet.longDescription)"
        planetDescriptionTextView.text = planetDescripton
        
        
    }
    
    // MARK: StarChart Core
    // Update Core
    func updateCore() {
        guard let planet = planet else { return }
        switch selectionContext {
        case .starChart:
            if planetSelected {
                if !StarChart.Core.selectedNodeTypes.contains(planet) {
                    StarChart.Core.selectedNodeTypes.append(planet)
                }
            } else {
                if StarChart.Core.selectedNodeTypes.contains(planet) {
                    StarChart.Core.selectedNodeTypes.removeAll { planetType in
                        planet == planetType
                    }
                }
            }
        case .aspectScanner:
            if planetSelected {
                if !AspectEventScanner.Core.planetsAndNodes.contains(planet) {
                    AspectEventScanner.Core.planetsAndNodes.append(planet)
                }
            } else {
                if AspectEventScanner.Core.planetsAndNodes.contains(planet) {
                    AspectEventScanner.Core.planetsAndNodes.removeAll { planetType in
                        planet == planetType
                    }
                }
            }
        }
    }
    
    // MARK: Settings
    // Set State
    func setSelectedState(selected:Bool) {
        if selected {
            self.alpha = 1
            self.backgroundColor = .systemBackground
            self.borderWidth = 1
            self.borderColor = .label
        } else {
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderWidth = 0
            self.borderColor = .clear
        }
    }
    
    
    // MARK: Animate
    // Animate Planets when Selected
    func animatePlanetSelected() {
        if planetSelected {
            // animate selection
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.alpha = 1
                self.backgroundColor = .systemBackground
                self.borderWidth = 1
                self.borderColor = .label
                
            } completion: { _ in
                self.alpha = 1
                self.backgroundColor = .systemBackground
                self.borderWidth = 1
                self.borderColor = .label
            }
        } else {
            // animate deselection
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.alpha = 0.5
                self.backgroundColor = .clear
                self.borderWidth = 0
                self.borderColor = .clear
            } completion: { _ in
                self.alpha = 0.5
                self.backgroundColor = .clear
                self.borderWidth = 0
                self.borderColor = .clear
            }
        }
    }
}
