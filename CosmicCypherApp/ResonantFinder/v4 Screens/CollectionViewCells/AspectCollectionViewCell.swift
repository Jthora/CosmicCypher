//
//  AspectCollectionViewCell.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/26/22.
//

import UIKit

class AspectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var aspectImageView: UIImageView!
    @IBOutlet weak var aspectLabel: UILabel!
    @IBOutlet weak var aspectSelectedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelectedState(selected:aspectSelected)
    }
    
    var aspectRelationType:CoreAstrology.AspectRelationType? = nil {
        didSet {
            update()
        }
    }
    
    var aspectSelected:Bool = true {
        didSet {
            updateCore()
            animateSelectedState()
        }
    }
    
    func updateCore() {
        guard let aspectRelationType = aspectRelationType else { return }
        if aspectSelected {
            if !StarChart.Core.selectedAspects.contains(aspectRelationType) {
                StarChart.Core.selectedAspects.append(aspectRelationType)
            }
        } else {
            if StarChart.Core.selectedAspects.contains(aspectRelationType) {
                StarChart.Core.selectedAspects.removeAll { aspectType in
                    aspectRelationType == aspectType
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
            self.aspectSelectedLabel.alpha = 1
        } else {
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderWidth = 0
            self.borderColor = .clear
            self.aspectSelectedLabel.alpha = 0
        }
    }
    
    func animateSelectedState() {
        if aspectSelected {
            // animate selection
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.alpha = 1
                self.backgroundColor = .systemBackground
                self.borderWidth = 1
                self.borderColor = .label
                self.aspectSelectedLabel.alpha = 1
                
            } completion: { _ in
                self.alpha = 1
                self.backgroundColor = .systemBackground
                self.borderWidth = 1
                self.borderColor = .label
                self.aspectSelectedLabel.alpha = 1
            }
        } else {
            // animate deselection
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.alpha = 0.5
                self.backgroundColor = .clear
                self.borderWidth = 0
                self.borderColor = .clear
                self.aspectSelectedLabel.alpha = 0
            } completion: { _ in
                self.alpha = 0.5
                self.backgroundColor = .clear
                self.borderWidth = 0
                self.borderColor = .clear
                self.aspectSelectedLabel.alpha = 0
            }
        }
    }
    
    func update() {
        guard let aspectRelationType = aspectRelationType else {
            aspectImageView.image = nil
            aspectLabel.text = ""
            return
        }
        aspectImageView.image = aspectRelationType.image
        aspectLabel.text = aspectRelationType.fraction
        aspectSelected = StarChart.Core.selectedAspects.contains(aspectRelationType)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                aspectSelected = !aspectSelected
            }
        }
    }
}
