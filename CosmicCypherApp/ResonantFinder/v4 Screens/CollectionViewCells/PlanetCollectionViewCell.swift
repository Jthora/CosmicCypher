//
//  PlanetCollectionViewCell.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/26/22.
//

import UIKit

class PlanetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var planetLabel: UILabel!
    @IBOutlet weak var planetSelectedLabel: UILabel!
    
    @IBOutlet weak var topZodiacImageView: UIImageView!
    @IBOutlet weak var bottomZodiacImageView: UIImageView!
    
    var selectionContext:PlanetSelectViewController.SelectionContext = .starChart
    
    var planet:CoreAstrology.AspectBody.NodeType? = nil {
        didSet {
            update()
        }
    }
    
    var alignment:AstrologicalNode? {
        guard let planet = planet else {return nil}
        return  StarChart.Core.current.alignments[planet]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelectedState(selected:planetSelected)
    }
    
    
    var planetSelected:Bool = true {
        didSet {
            updateCore()
            animatePlanetSelected()
        }
    }
    
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
    
    func setSelectedState(selected:Bool) {
        if selected {
            self.alpha = 1
            self.backgroundColor = .systemBackground
            self.borderWidth = 1
            self.borderColor = .label
            self.planetSelectedLabel.alpha = 1
        } else {
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderWidth = 0
            self.borderColor = .clear
            self.planetSelectedLabel.alpha = 0
        }
    }
    
    func animatePlanetSelected() {
        if planetSelected {
            // animate selection
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.alpha = 1
                self.backgroundColor = .systemBackground
                self.borderWidth = 1
                self.borderColor = .label
                self.planetSelectedLabel.alpha = 1
                
            } completion: { _ in
                self.alpha = 1
                self.backgroundColor = .systemBackground
                self.borderWidth = 1
                self.borderColor = .label
                self.planetSelectedLabel.alpha = 1
            }
        } else {
            // animate deselection
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.alpha = 0.5
                self.backgroundColor = .clear
                self.borderWidth = 0
                self.borderColor = .clear
                self.planetSelectedLabel.alpha = 0
            } completion: { _ in
                self.alpha = 0.5
                self.backgroundColor = .clear
                self.borderWidth = 0
                self.borderColor = .clear
                self.planetSelectedLabel.alpha = 0
            }
        }
    }
    
    
    func update() {
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
        
        if let chevron = alignment?.createChevron() {
            topZodiacImageView.image = chevron.topZodiac.image
            bottomZodiacImageView.image = chevron.bottomZodiac.image
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                planetSelected = !planetSelected
            }
        }
    }
}
