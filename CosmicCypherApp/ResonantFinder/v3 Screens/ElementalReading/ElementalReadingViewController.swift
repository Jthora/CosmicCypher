//
//  ElementalReadingViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 12/3/20.
//

import UIKit

class ElementalReadingViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "ElementalReading", bundle: nil).instantiateViewController(withIdentifier: "ElementalReadingViewController") as? ElementalReadingViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            // Presented
        }
        
    }
    
    @IBOutlet weak var barViewFire: UIProgressView!
    @IBOutlet weak var barViewAir: UIProgressView!
    @IBOutlet weak var barViewWater: UIProgressView!
    @IBOutlet weak var barViewEarth: UIProgressView!
    @IBOutlet weak var barViewAether: UIProgressView!
    @IBOutlet weak var barViewNether: UIProgressView!
    
    @IBOutlet weak var barViewSpiritPotential: UIProgressView!
    @IBOutlet weak var barViewSpiritBaseline: UIProgressView!
    @IBOutlet weak var barViewSpiritExpected: UIProgressView!
    
    @IBOutlet weak var barViewHolyPotential: UIProgressView!
    @IBOutlet weak var barViewHolyBaseline: UIProgressView!
    @IBOutlet weak var barViewHolyExpected: UIProgressView!
    
    @IBOutlet weak var barViewEvilPotential: UIProgressView!
    @IBOutlet weak var barViewEvilBaseline: UIProgressView!
    @IBOutlet weak var barViewEvilExpected: UIProgressView!
    
    @IBOutlet weak var barViewBodyPotential: UIProgressView!
    @IBOutlet weak var barViewBodyBaseline: UIProgressView!
    @IBOutlet weak var barViewBodyExpected: UIProgressView!
    
    @IBOutlet weak var barViewCorePotential: UIProgressView!
    @IBOutlet weak var barViewCoreBaseline: UIProgressView!
    @IBOutlet weak var barViewCoreExpected: UIProgressView!
    
    @IBOutlet weak var barViewVoidPotential: UIProgressView!
    @IBOutlet weak var barViewVoidBaseline: UIProgressView!
    @IBOutlet weak var barViewVoidExpected: UIProgressView!
    
    @IBOutlet weak var barViewAlphaPotential: UIProgressView!
    @IBOutlet weak var barViewAlphaBaseline: UIProgressView!
    @IBOutlet weak var barViewAlphaExpected: UIProgressView!
    
    @IBOutlet weak var barViewOmegaPotential: UIProgressView!
    @IBOutlet weak var barViewOmegaBaseline: UIProgressView!
    @IBOutlet weak var barViewOmegaExpected: UIProgressView!
    
    @IBOutlet weak var barViewOrderPotential: UIProgressView!
    @IBOutlet weak var barViewOrderBaseline: UIProgressView!
    @IBOutlet weak var barViewOrderExpected: UIProgressView!
    
    @IBOutlet weak var barViewChaosPotential: UIProgressView!
    @IBOutlet weak var barViewChaosBaseline: UIProgressView!
    @IBOutlet weak var barViewChaosExpected: UIProgressView!
    
    
    
//        case expected
//        case potential
//        case baseline
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        update()
    }
    
    func setup() {
        
        barViewFire.progressTintColor = UIColor.from(.fire)
        barViewAir.progressTintColor = UIColor.from(.air)
        barViewWater.progressTintColor = UIColor.from(.water)
        barViewEarth.progressTintColor = UIColor.from(.earth)
        barViewAether.progressTintColor = UIColor.from(.poly)
        barViewNether.progressTintColor = UIColor.from(.mono)
        
        barViewSpiritExpected.progressTintColor = UIColor.from(.spirit).withAlphaComponent(0.75)
        barViewSpiritPotential.progressTintColor = UIColor.from(.spirit).withAlphaComponent(0.5)
        barViewSpiritBaseline.progressTintColor = UIColor.from(.spirit)
        
        barViewHolyExpected.progressTintColor = UIColor.from(.light).withAlphaComponent(0.75)
        barViewHolyPotential.progressTintColor = UIColor.from(.light).withAlphaComponent(0.5)
        barViewHolyBaseline.progressTintColor = UIColor.from(.light)
        
        barViewEvilExpected.progressTintColor = UIColor.from(.shadow).withAlphaComponent(0.75)
        barViewEvilPotential.progressTintColor = UIColor.from(.shadow).withAlphaComponent(0.5)
        barViewEvilBaseline.progressTintColor = UIColor.from(.shadow)
        
        barViewBodyExpected.progressTintColor = UIColor.from(.soul).withAlphaComponent(0.75)
        barViewBodyPotential.progressTintColor = UIColor.from(.soul).withAlphaComponent(0.5)
        barViewBodyBaseline.progressTintColor = UIColor.from(.soul)
        
        barViewCoreExpected.progressTintColor = UIColor.from(.core).withAlphaComponent(0.75)
        barViewCorePotential.progressTintColor = UIColor.from(.core).withAlphaComponent(0.5)
        barViewCoreBaseline.progressTintColor = UIColor.from(.core)
        
        barViewVoidExpected.progressTintColor = UIColor.from(.void).withAlphaComponent(0.75)
        barViewVoidPotential.progressTintColor = UIColor.from(.void).withAlphaComponent(0.5)
        barViewVoidBaseline.progressTintColor = UIColor.from(.void)
        
        barViewAlphaExpected.progressTintColor = UIColor.from(.alpha).withAlphaComponent(0.75)
        barViewAlphaPotential.progressTintColor = UIColor.from(.alpha).withAlphaComponent(0.5)
        barViewAlphaBaseline.progressTintColor = UIColor.from(.alpha)
        
        barViewOmegaExpected.progressTintColor = UIColor.from(.omega).withAlphaComponent(0.75)
        barViewOmegaPotential.progressTintColor = UIColor.from(.omega).withAlphaComponent(0.5)
        barViewOmegaBaseline.progressTintColor = UIColor.from(.omega)
        
        barViewOrderExpected.progressTintColor = UIColor.from(.order).withAlphaComponent(0.75)
        barViewOrderPotential.progressTintColor = UIColor.from(.order).withAlphaComponent(0.5)
        barViewOrderBaseline.progressTintColor = UIColor.from(.order)
        
        barViewChaosExpected.progressTintColor = UIColor.from(.chaos).withAlphaComponent(0.75)
        barViewChaosPotential.progressTintColor = UIColor.from(.chaos).withAlphaComponent(0.5)
        barViewChaosBaseline.progressTintColor = UIColor.from(.chaos)
    }
    
    func update() {
        
        let cosmicAlignment = StarChart.Core.currentCosmicAlignment
        
        barViewFire.progress = cosmicAlignment.level(.fire, .baseline)
        barViewAir.progress = cosmicAlignment.level(.air, .baseline)
        barViewWater.progress = cosmicAlignment.level(.water, .baseline)
        barViewEarth.progress = cosmicAlignment.level(.earth, .baseline)
        barViewAether.progress = cosmicAlignment.level(.poly, .baseline)
        barViewNether.progress = cosmicAlignment.level(.mono, .baseline)
        
        barViewSpiritExpected.progress = cosmicAlignment.level(.spirit, .expected)
        barViewSpiritPotential.progress = cosmicAlignment.level(.spirit, .potential)
        barViewSpiritBaseline.progress = cosmicAlignment.level(.spirit, .baseline)
        
        barViewHolyExpected.progress = cosmicAlignment.level(.light, .expected)
        barViewHolyPotential.progress = cosmicAlignment.level(.light, .potential)
        barViewHolyBaseline.progress = cosmicAlignment.level(.light, .baseline)
        
        barViewEvilExpected.progress = cosmicAlignment.level(.shadow, .expected)
        barViewEvilPotential.progress = cosmicAlignment.level(.shadow, .potential)
        barViewEvilBaseline.progress = cosmicAlignment.level(.shadow, .baseline)
        
        barViewBodyExpected.progress = cosmicAlignment.level(.soul, .expected)
        barViewBodyPotential.progress = cosmicAlignment.level(.soul, .potential)
        barViewBodyBaseline.progress = cosmicAlignment.level(.soul, .baseline)
        
        barViewCoreExpected.progress = cosmicAlignment.level(.core, .expected)
        barViewCorePotential.progress = cosmicAlignment.level(.core, .potential)
        barViewCoreBaseline.progress = cosmicAlignment.level(.core, .baseline)
        
        barViewVoidExpected.progress = cosmicAlignment.level(.void, .expected)
        barViewVoidPotential.progress = cosmicAlignment.level(.void, .potential)
        barViewVoidBaseline.progress = cosmicAlignment.level(.void, .baseline)
        
        barViewAlphaExpected.progress = cosmicAlignment.level(.alpha, .expected)
        barViewAlphaPotential.progress = cosmicAlignment.level(.alpha, .potential)
        barViewAlphaBaseline.progress = cosmicAlignment.level(.alpha, .baseline)
        
        barViewOmegaExpected.progress = cosmicAlignment.level(.omega, .expected)
        barViewOmegaPotential.progress = cosmicAlignment.level(.omega, .potential)
        barViewOmegaBaseline.progress = cosmicAlignment.level(.omega, .baseline)
        
        barViewOrderExpected.progress = cosmicAlignment.level(.order, .expected)
        barViewOrderPotential.progress = cosmicAlignment.level(.order, .potential)
        barViewOrderBaseline.progress = cosmicAlignment.level(.order, .baseline)
        
        barViewChaosExpected.progress = cosmicAlignment.level(.chaos, .expected)
        barViewChaosPotential.progress = cosmicAlignment.level(.chaos, .potential)
        barViewChaosBaseline.progress = cosmicAlignment.level(.chaos, .baseline)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
