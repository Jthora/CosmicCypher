//
//  SettingsViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/23/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    // MARK: Outlets
    // Buttons
    @IBOutlet weak var setTimeAndGeoLocationButton: UIButton!
    
    // Text Fields
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    // Text Views
    @IBOutlet weak var selectedNodesTextView: UITextView!
    @IBOutlet weak var selectedAspectsTextView: UITextView!
    
    
    
    // MARK: Setup
    // Load ViewController from Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    // Setup
    func setup() {
        setupTextFields()
        setupTextViews()
    }
    
    // Setup TextFields
    func setupTextFields() {
        let date = StarChart.Core.current.date
        let coordinates = StarChart.Core.current.coordinates
        dateTextField.text = date.text(.mediumDate)
        timeTextField.text = date.text(.mediumTime)
        latitudeTextField.text = "\(coordinates.latitude)"
        longitudeTextField.text = "\(coordinates.longitude)"
    }
    
    func setupTextViews() {
        let planetNodeSymbols = StarChart.Core.selectedNodeTypes.map { $0.symbol }
        let aspectSymbols = StarChart.Core.selectedAspects.map { $0.symbol }
        selectedNodesTextView.text = "Selected Nodes: \(planetNodeSymbols.joined())"
        selectedAspectsTextView.text = "Selected Aspects: \(aspectSymbols.joined())"
    }
    
    // MARK: Button Actions
    // Set Time and GeoLocation
    @IBAction func setTimeAndGeoLocationButtonAction(_ sender: UIButton) {
        //GeoLocationSelectViewController.presentModally(over: self, originViewController: nil)
        //GeoLocationAndTimeSelectViewController.presentModally(over: self)
        StarChartSelectViewController.presentModally(over: self)
    }
    
    // Set PlanetNodes and Aspects
    @IBAction func setPlanetNodesAndAspectsButtonAction(_ sender: UIButton) {
        PlanetNodeAndAspectSelectViewController.presentModally(over: self, selectionContext: .starChart)
    }
    
    
    
    // Allow the view controller to handle key commands
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // Define the key commands
    override var keyCommands: [UIKeyCommand]? {
        let commandA = UIKeyCommand(input: "A", modifierFlags: [.control], action: #selector(triggerButtonA))
        commandA.discoverabilityTitle = "Set Time and GeoLocation"
        
        let commandB = UIKeyCommand(input: "B", modifierFlags: [.control], action: #selector(triggerButtonB))
        commandA.discoverabilityTitle = "Dismiss"

        return [commandA, commandB]
    }
    
    // Actions for key commands
    @objc func triggerButtonA() {
        setTimeAndGeoLocationButton.sendActions(for: .touchUpInside)
    }
    
    // Actions for key commands
    @objc func triggerButtonB() {
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }
    
    
}
