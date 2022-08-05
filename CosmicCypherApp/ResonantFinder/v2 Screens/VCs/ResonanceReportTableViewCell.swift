//
//  ResonanceReportTableViewCell.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 12/5/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import SwiftAA

class ResonanceReportTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rightPlanetImageView: UIImageView!
    @IBOutlet weak var leftPlanetImageView: UIImageView!
    @IBOutlet weak var aspectImageView: UIImageView!
    @IBOutlet weak var rightPlanetTopImageView: UIImageView!
    @IBOutlet weak var rightPlanetBottomImageView: UIImageView!
    @IBOutlet weak var leftPlanetTopImageView: UIImageView!
    @IBOutlet weak var leftPlanetBottomImageView: UIImageView!
    
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var orbLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with aspect:CoreAstrology.Aspect, primaryBodyLongitude:Degree, secondaryBodyLongitude:Degree) {
        
        // Distance
        var degrees = aspect.relation.degrees.value.truncatingRemainder(dividingBy: 360)
        var positive = "+"
        
        
        // TODO:: GET VELOCITY from StarChartAspect
        var upDownString = "⇧"
        
        if degrees > 180 {
            degrees = 180-(degrees-180)
        }
        
        let distance = degrees - (aspect.relation.type.degree.value)
        
        let distanceString:String
        
        if distance.rounded(toIncrement: 0.1) > 0 {
            positive = "+"
            distanceString = String(format:"%0.1f", distance)
        } else if distance.rounded(toIncrement: 0.1) < 0 {
            positive = ""
            distanceString = String(format:"%0.1f", distance)
        } else {
            positive = ""
            distanceString = String(format:"%0.0f", distance)
        }
        
        
        distanceLabel.text = "[\(positive)\(distanceString)º]\(upDownString)"
        
        // Orb and Concentration
        let concentration = aspect.relation.concentration
        let orb = aspect.relation.type.orb.value
        orbLabel.text = "○ \(String(format:"%0.2f", orb))º"
        powerLabel.text = "\(String(format:"%0.1f", (concentration * 100)))%"
        
        // Fraction
        let fraction = aspect.relation.type.fraction
        fractionLabel.text = "<\(fraction)>"
        
        // Left Planet
        leftPlanetImageView.image = aspect.primaryBody.type.image
        
        let leftPrimaryZodiac = Arcana.Zodiac.from(degree: primaryBodyLongitude)
        let leftSecondaryZodiac = Arcana.Zodiac.subFrom(degree: primaryBodyLongitude)
        if leftPrimaryZodiac.duality == .yang {
            leftPlanetTopImageView.image = leftPrimaryZodiac.image
            leftPlanetBottomImageView.image = leftSecondaryZodiac.image
        } else {
            leftPlanetTopImageView.image = leftSecondaryZodiac.image
            leftPlanetBottomImageView.image = leftPrimaryZodiac.image
        }
        
        // Right Planet
        rightPlanetImageView.image = aspect.secondaryBody.type.image
        
        let rightPrimaryZodiac = Arcana.Zodiac.from(degree: secondaryBodyLongitude)
        let rightSecondaryZodiac = Arcana.Zodiac.subFrom(degree: secondaryBodyLongitude)
        if rightPrimaryZodiac.duality == .yang {
            rightPlanetTopImageView.image = rightPrimaryZodiac.image
            rightPlanetBottomImageView.image = rightSecondaryZodiac.image
        } else {
            rightPlanetTopImageView.image = rightSecondaryZodiac.image
            rightPlanetBottomImageView.image = rightPrimaryZodiac.image
        }
        
        
        // Central Aspect
        aspectImageView.image = aspect.relation.type.image
        
    }

}
