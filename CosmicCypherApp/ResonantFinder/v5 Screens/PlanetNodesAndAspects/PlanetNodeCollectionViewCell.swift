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
    
    // Labels
    @IBOutlet weak var planetLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topPercentLabel: UILabel!
    @IBOutlet weak var bottomPercentLabel: UILabel!
    
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
    var alignment:AstrologicalNode? {
        guard let planet = planet else {return nil}
        return  StarChart.Core.current.alignments[planet]
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
    }
    
    // Update Zodiac Content
    func updateTopAndBottomDetails() {
        guard let planet = planet,
              let chevron = alignment?.createChevron() else {
            topZodiacImageView.image = nil
            bottomZodiacImageView.image = nil
            topLabel.text = ""
            bottomLabel.text = ""
            return
        }
        topZodiacImageView.image = chevron.topZodiac.image
        bottomZodiacImageView.image = chevron.bottomZodiac.image
        topLabel.text = "\(chevron.topZodiac.text)\n\(chevron.topZodiac.chineseZodiacText)"
        bottomLabel.text = "\(chevron.bottomZodiac.text)\n\(chevron.bottomZodiac.chineseZodiacText)"
        
        topTextView.text = chevron.topZodiac.description
        bottomTextView.text = chevron.bottomZodiac.description
    }
    
    // Update
    func updateAstronomyDetails() {
        guard let planet = planet else {
            planetImageView.image = nil
            planetLabel.text = ""
            return
        }
        
        let planetDescripton:String = planet.shortDescription
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
