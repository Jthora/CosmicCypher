//
//  CelestialEventScanViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/21/23.
//

import Foundation
import UIKit
import CoreLocation

class CelestialEventScanViewController: UIViewController {
    
    // MARK: Modal Presentation
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "CelestialEventScan", bundle: nil).instantiateViewController(withIdentifier: "CelestialEventScanViewController") as? CelestialEventScanViewController else {
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
    
    @IBOutlet weak var optionsMenuButton: UIButton!
    
    @IBOutlet weak var segmentedControlSampleMode: UISegmentedControl!
    @IBOutlet weak var switchDeepScan: UISwitch!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var subProgressBar: UIProgressView!
    @IBOutlet weak var calculateProgressBar: UIProgressView!
    @IBOutlet weak var deepScanProgressBar: UIProgressView!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var textViewConsole: UITextView!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var buttonClear: UIButton!
    
    @IBOutlet weak var buttonScan: UIButton!
    @IBOutlet weak var buttonParse: UIButton!
    @IBOutlet weak var buttonExport: UIButton!
    
    // MARK: Properties
    
    // MARK: Accessors
    var scanner:CelestialEventScanner { return CelestialEventScanner.Core.scanner }
    var sampleMode: CelestialEventScanner.SampleMode {
        get {
            return scanner.sampleMode
        }
        set {
            scanner.sampleMode = newValue
        }
    }
    var useDeepScan:Bool {
        get {
            return scanner.useDeepScan
        }
        set {
            scanner.useDeepScan = newValue
        }
    }
    
    // MARK: UI
    // Load from Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        scanner.console?.delegate = self
        scanner.delegate = self
    }
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner.console?.delegate = self
        scanner.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        // Fill Longitude and Latitude
        let location = CLLocation(latitude: scanner.latitude, longitude: scanner.longitude)
        textFieldLongitude.text = "\(location.coordinate.longitude)"
        textFieldLatitude.text = "\(location.coordinate.latitude)"
        
        // Fill Planets and Nodes
        let planetNodeSymbols:[String] = scanner.selectedNodeTypes.map { $0.symbol }
        let aspectSymbols:[String] = scanner.selectedAspects.map { $0.symbol }
        
        textViewPlanetsAndNodes.text = planetNodeSymbols.joined()
        textViewAspectAngles.text = aspectSymbols.joined()
        
        scanner.console?.update()
    }
    
    // MARK: Setup Options
    // Setup Option Buttons
    func setupOptionButton() {
        // drop down for Chart Data Mode Select
        
        let menu = UIMenu(children: [
            UIAction(title: "Retrogrades", handler:toggleRetrogradeScan)])
        optionsMenuButton.menu = menu
    }
    
    // MARK: Scan Option Toggle Functions
    // Retrograde Scan Option
    func toggleRetrogradeScan(action: UIAction) {
        CelestialEventScanner.Core.retrogradeScanEnabled = action.state == .on
    }
    
    // Aspect Scan Option
    func toggleAspectScan(action: UIAction) {
        CelestialEventScanner.Core.aspectScanEnabled = action.state == .on
    }
    
    // Retrograde Scan Option
    func toggleTransitScan(action: UIAction) {
        CelestialEventScanner.Core.transitScanEnabled = action.state == .on
    }
    
    // Retrograde Scan Option
    func toggleFormationScan(action: UIAction) {
        CelestialEventScanner.Core.formationScanEnabled = action.state == .on
    }
    
    // Retrograde Scan Option
    func toggleOctiveScan(action: UIAction) {
        CelestialEventScanner.Core.octiveScanEnabled = action.state == .on
    }
    // Retrograde Scan Option
    func toggleResonanceScan(action: UIAction) {
        CelestialEventScanner.Core.resonanceScanEnabled = action.state == .on
    }
    
    // MARK: IBAction Button Press Responders
    // Start Date Picker
    @IBAction func startDatePickerDidChange(_ sender: UIDatePicker) {
        // Update Scanner
        scanner.startDate = sender.date
        
        // check if new start date is after end date
        if sender.date > endDatePicker.date {
            endDatePicker.date = sender.date
            scanner.endDate = endDatePicker.date
        }
    }
    // End Date Picker
    @IBAction func endDatePickerDidChange(_ sender: UIDatePicker) {
        // check date if it's before End Date
        if sender.date < startDatePicker.date {
            startDatePicker.date = sender.date
            scanner.startDate = startDatePicker.date
        }
        
        // Update Scanner
        scanner.endDate = sender.date
    }
    // Longitude Text Field Edited
    @IBAction func longitudeDidChange(_ sender: UITextField) {
        guard sender.text?.isEmpty == false,
              let string = sender.text,
              let newLongitude = Double(string) else {
            let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)
            textFieldLongitude.text = "\(location.coordinate.longitude)"
            return
        }
        
    }
    // Latitude Text Field Edited
    @IBAction func latitudeDidChange(_ sender: UITextField) {
        guard sender.text?.isEmpty == false,
              let string = sender.text,
                let newLatitude = Double(string) else {
            let location = CLLocation(latitude: StarChart.Core.current.coordinates.latitude.value, longitude: -StarChart.Core.current.coordinates.longitude.value)
            textFieldLatitude.text = "\(location.coordinate.latitude)"
            return
        }
    }
    // Set Location Button Action
    @IBAction func buttonSetLocation(_ sender: UIButton) {
        GeoLocationSelectViewController.presentModally(over: self, originViewController: self) {
            self.updateUI()
        }
    }
    // Select Button Action
    @IBAction func buttonSelect(_ sender: UIButton) {
        PlanetNodeAndAspectSelectViewController.presentModally(over: self, selectionContext: .scanner) {
            self.updateUI()
        }
    }
    
    @IBAction func optionsMenuButtonTouch(_ sender: UIButton) {
        
    }
    
    // Sample Mode Control Changed
    @IBAction func sampleModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        let i = sender.selectedSegmentIndex
        guard let newSampleMode = CelestialEventScanner.SampleMode(rawValue: i) else { return }
        self.sampleMode = newSampleMode
    }
    // Use Deep Scan On/Off
    @IBAction func deepScanSwitchChanged(_ sender: UISwitch) {
        useDeepScan = sender.isOn
    }
    // Scan Button Action
    @IBAction func buttonScan(_ sender: UIButton) {
        // Activates the Scanner
        CelestialEventScanner.Core.scan()
        buttonScan.isEnabled = false
        
        // TODO: While Scanning, the Scan Button turns into a Red Stop Button.
    }
    // Time Maps
    @IBAction func buttonMaps(_ sender: UIButton) {
        // TODO: Create a new Time Maps Screen to go to (Spectrographs of Spectrograms on a table)
        
    }
    
    // Export Button Action
    @IBAction func buttonExport(_ sender: UIButton) {
        CelestialEventExportViewController.presentModally(over: self)
    }
    // Clear Console
    @IBAction func buttonClear(_ sender: UIButton) {
        scanner.console?.clear()
    }
    
}


// MARK: TextField Delegate

extension CelestialEventScanViewController: UITextFieldDelegate {
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

// MARK: Aspect Event Console Delegate
extension CelestialEventScanViewController: CelestialEventConsoleDelegate {
    // Console Updated
    func consoleUpdated(text: String) {
        DispatchQueue.main.async {
            self.textViewConsole.text = text
        }
    }
}

// MARK: Aspect Event Scanner Delegate
extension CelestialEventScanViewController: CelestialEventScannerDelegate {
    
    // Update (Scan)
    func scanUpdate(scanProgress: Float?) {
        DispatchQueue.main.async {
            if let progress = scanProgress {
                self.progressBar.progress = progress
            }
        }
    }
    // Update (Sub Scan)
    func scanUpdate(subScanProgress: Float?) {
        DispatchQueue.main.async {
            if let subScanProgress = subScanProgress {
                self.subProgressBar.progress = subScanProgress
            }
        }
    }
    // Update (Calculate)
    func scanUpdate(calculateProgress: Float?) {
        DispatchQueue.main.async {
            if let calculateProgress = calculateProgress {
                self.calculateProgressBar.progress = calculateProgress
            }
        }
    }
    // Update (Deep Scan)
    func scanUpdate(deepScanProgress: Float?) {
        DispatchQueue.main.async {
            if let deepScanProgress = deepScanProgress {
                self.deepScanProgressBar.progress = deepScanProgress
            }
        }
    }
    
    // Scan Complete
    func scanComplete(aspectsFound: [Date : [CoreAstrology.Aspect]]) {
        DispatchQueue.main.async {
            self.progressBar.progress = 1.0
            self.subProgressBar.progress = 1.0
            self.buttonScan.isEnabled = true
        }
    }
    
    // Deep Scan Complete
    func deepScanComplete(date: Date) {
        DispatchQueue.main.async {
            self.deepScanProgressBar.progress = 0
            self.deepScanProgressBar.isHidden = true
            self.buttonScan.isEnabled = true
        }
    }
    
    // Scan Error
    func scanError(error: CelestialEventScanner.ScanError) {
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
extension CelestialEventScanViewController: StarChartRegistryCacheWarningDelegate {
    
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
