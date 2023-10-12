//
//  AspectEventScanViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/21/23.
//

import Foundation
import UIKit
import CoreLocation

class AspectEventScanViewController: UIViewController {
    
    // MARK: Modal Presentation
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "AspectEventScan", bundle: nil).instantiateViewController(withIdentifier: "AspectEventScanViewController") as? AspectEventScanViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    
    // MARK: IBOutlet UI References
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var textFieldLongitude: UITextField!
    @IBOutlet weak var textFieldLatitude: UITextField!
    
    @IBOutlet weak var textViewPlanetsAndNodes: UITextView!
    @IBOutlet weak var textViewAspectAngles: UITextView!
    
    @IBOutlet weak var segmentedControlSampleMode: UISegmentedControl!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var subProgressBar: UIProgressView!
    
    @IBOutlet weak var textViewConsole: UITextView!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var buttonScan: UIButton!
    @IBOutlet weak var buttonParse: UIButton!
    @IBOutlet weak var buttonExport: UIButton!
    
    
    // MARK: Helpers
    
    var scanner:AspectEventScanner { return AspectEventScanner.Core.scanner }
    
    
    // MARK: UI
    
    override func viewDidLoad() {
        scanner.console?.delegate = self
        scanner.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        // Fill Longitude and Latitude
        let location = CLLocation(latitude: scanner.latitude, longitude: scanner.longitude)
        textFieldLongitude.text = "\(location.coordinate.longitude)"
        textFieldLatitude.text = "\(location.coordinate.latitude)"
        
        // Fill Planets and Nodes
        let planetNodeSymbols:[String] = scanner.selectedNodeTypes.map { nodeType in
            return "\(nodeType.symbol) "
        }
        let aspectSymbols:[String] = scanner.selectedAspects.map { aspect in
            return "(\(aspect.symbol)) "
        }
        
        textViewPlanetsAndNodes.text = planetNodeSymbols.joined()
        textViewAspectAngles.text = aspectSymbols.joined()
        
        scanner.console?.updateDelegate()
    }
    
    
    // MARK: IBAction Button Press Responders
    
    @IBAction func startDatePickerDidChange(_ sender: UIDatePicker) {
        // Update Scanner
        scanner.startDate = sender.date
        
        // check if new start date is after end date
        if sender.date > endDatePicker.date {
            endDatePicker.date = sender.date
            scanner.endDate = endDatePicker.date
        }
    }
    
    @IBAction func endDatePickerDidChange(_ sender: UIDatePicker) {
        // check date if it's before End Date
        if sender.date < startDatePicker.date {
            startDatePicker.date = sender.date
            scanner.startDate = startDatePicker.date
        }
        
        // Update Scanner
        scanner.endDate = sender.date
    }
    
    @IBAction func longitudeDidChange(_ sender: UITextField) {
        guard sender.text?.isEmpty == false,
              let string = sender.text,
              let newLongitude = Double(string) else {
            let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)
            textFieldLongitude.text = "\(location.coordinate.longitude)"
            return
        }
        
    }
    
    @IBAction func latitudeDidChange(_ sender: UITextField) {
        guard sender.text?.isEmpty == false,
              let string = sender.text,
                let newLatitude = Double(string) else {
            let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)
            textFieldLatitude.text = "\(location.coordinate.latitude)"
            return
        }
    }
    
    @IBAction func buttonSetLocation(_ sender: UIButton) {
        GeoLocationSelectViewController.presentModally(over: self, originViewController: self) {
            self.updateUI()
        }
    }
    
    @IBAction func buttonSelect(_ sender: UIButton) {
        PlanetSelectViewController.presentModally(over: self, selectionContext: .aspectScanner) {
            self.updateUI()
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        // Changes the mode so Aspect Events are more accurately scanned for
        // Simple sets it to only look at which Day the aspect event occurs
        // Precise sets it to look down to the Second when the aspect event occurs on that Day
    }
    
    
    @IBAction func buttonScan(_ sender: UIButton) {
        // Activates the Scanner
        AspectEventScanner.Core.scan()
        buttonScan.isEnabled = false
    }
    
    @IBAction func buttonParse(_ sender: UIButton) {
    }
    
    @IBAction func buttonExport(_ sender: UIButton) {
        AspectEventExportViewController.presentModally(over: self)
    }
    
    
}


// MARK: TextField Delegate

extension AspectEventScanViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Only applies to Lat Long text fields
        guard textField == textFieldLatitude || textField == textFieldLongitude else {return true}
        
        // Allow the backspace key
        if string.isEmpty {
            return true
        }

        // Create a character set containing all valid characters (0-9 and .)
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)

        // Check if the replacement string contains only valid characters
        if !allowedCharacterSet.isSuperset(of: replacementStringCharacterSet) {
            return false
        }

        // Check if the current text with the replacementString is a valid number
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            return true // Allow empty text field if desired
        }

        // Use NumberFormatter to check if it's a valid number (integer or floating-point)
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        if let number = formatter.number(from: newText) {
            return true
        } else {
            return false
        }
    }
}


// MARK: Scanner & Console Delegates

extension AspectEventScanViewController: AspectEventConsoleDelegate {
    func consoleUpdated(text: String) {
        DispatchQueue.main.async {
            self.textViewConsole.text = text
        }
    }
}

extension AspectEventScanViewController: AspectEventScannerDelegate {
    
    func scanUpdate(progress: Float?, subProgress: Float?) {
        DispatchQueue.main.async {
            if let progress = progress {
                self.progressBar.progress = progress
            }
            if let subProgress = subProgress {
                self.subProgressBar.progress = subProgress
            }
        }
    }
    
    func scanComplete(aspectsFound: [Date : [CoreAstrology.Aspect]]) {
        DispatchQueue.main.async {
            self.progressBar.progress = 1.0
            self.subProgressBar.progress = 1.0
            self.buttonScan.isEnabled = true
        }
    }
    
    func scanError(error: AspectEventScanner.AspectScanError) {
        switch error {
        default:
            DispatchQueue.main.async {
                self.progressBar.progress = 0
                self.subProgressBar.progress = 0
                self.buttonScan.isEnabled = true
            }
        }
    }
}


// MARK: Handle Popups and UI Controls for StarChart Cache Warnings

extension AspectEventExportViewController: StarChartRegistryCacheWarningDelegate {
    
    // Delegate function for cache warning
    func cacheWarning(threshold: Int) {
        showCacheWarningPopup(threshold: threshold)
    }
    
    // Function to show a cache warning popup
    func showCacheWarningPopup(threshold: Int) {
        let alertController = UIAlertController(title: "Cache Warning", message: "The cache is getting full. Please clear it to free up space. Threshold: \(threshold) starCharts", preferredStyle: .alert)
        let ignoreAction = UIAlertAction(title: "Ignore", style: .cancel, handler: nil)
        let clearAction = UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            StarChartRegistry.main.resetCache()
            DispatchQueue.main.async {
                self.showCacheClearedPopup()
            }
        })
        alertController.addAction(ignoreAction)
        alertController.addAction(clearAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to show a cache cleared notification popup
    func showCacheClearedPopup() {
        let alertController = UIAlertController(title: "Cache Cleared", message: "The cache has been cleared and reset.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
