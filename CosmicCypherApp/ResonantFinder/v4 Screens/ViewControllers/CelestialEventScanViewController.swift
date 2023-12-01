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
        update()
        setupOptionButton()
    }
    
    func update() {
        updateText()
        updateConsole()
        updateStartAndEndDates()
    }
    
    func updateText() {
        // Fill Longitude and Latitude
        let location = CLLocation(latitude: scanner.latitude, longitude: scanner.longitude)
        textFieldLongitude.text = "\(location.coordinate.longitude)"
        textFieldLatitude.text = "\(location.coordinate.latitude)"
        
        // Fill Planets and Nodes
        let planetNodeSymbols:[String] = scanner.selectedNodeTypes.map { $0.symbol }
        let aspectSymbols:[String] = scanner.selectedAspects.map { $0.symbol }
        
        textViewPlanetsAndNodes.text = planetNodeSymbols.joined()
        textViewAspectAngles.text = aspectSymbols.joined()
    }
    
    func updateConsole() {
        scanner.console?.update()
    }
    
    func updateStartAndEndDates() {
        startDatePicker.date = scanner.startDate
        endDatePicker.date = scanner.endDate
    }
    
    // MARK: Setup Sub Scan Options
    // Setup Option Buttons
    var retrogradeCommand: UICommand? = nil
    var transitCommand: UICommand? = nil
    var aspectCommand: UICommand? = nil
    var formationCommand: UICommand? = nil
    var octiveCommand: UICommand? = nil
    var resonanceCommand: UICommand? = nil
    
    // Setup Menu for Sub Scan Options
    func setupOptionButton() {
        /// Retrograde Command
        retrogradeCommand = UICommand(title: CoreAstrology.CelestialEventType.menuItemTitle(.retrograde(.stationary)),
                                      image: CoreAstrology.CelestialEventType.systemImage(.retrograde(.stationary)), 
                                      action: #selector(toggleRetrogradeScan(_:)),
                                      state: CelestialEventScanner.Core.retrogradeScanEnabled ? .on : .off)
        /// Transit Command
        transitCommand = UICommand(title: CoreAstrology.CelestialEventType.menuItemTitle(.transit(.zodiac(.aries))),
                                   image: CoreAstrology.CelestialEventType.systemImage(.transit(.zodiac(.aries))),
                                   action: #selector(toggleTransitScan(_:)),
                                   state: CelestialEventScanner.Core.transitScanEnabled ? .on : .off)
        transitCommand?.attributes = [.disabled]
        /// Aspect Command
        aspectCommand = UICommand(title: CoreAstrology.CelestialEventType.menuItemTitle(.aspect(.conjunction)),
                                  image: CoreAstrology.CelestialEventType.systemImage(.aspect(.conjunction)),
                                  action: #selector(toggleAspectScan(_:)),
                                  state: CelestialEventScanner.Core.aspectScanEnabled ? .on : .off)
        aspectCommand?.attributes = [.disabled]
        /// Formation Command
        formationCommand = UICommand(title: CoreAstrology.CelestialEventType.menuItemTitle(.formation(.grandTrine)),
                                     image: CoreAstrology.CelestialEventType.systemImage(.formation(.grandTrine)),
                                     action: #selector(toggleFormationScan(_:)),
                                     state: CelestialEventScanner.Core.formationScanEnabled ? .on : .off)
        formationCommand?.attributes = [.disabled]
        /// Octive Command
        octiveCommand = UICommand(title: CoreAstrology.CelestialEventType.menuItemTitle(.octive(.triangle)),
                                  image: CoreAstrology.CelestialEventType.systemImage(.octive(.triangle)),
                                  action: #selector(toggleOctiveScan(_:)),
                                  state: CelestialEventScanner.Core.octiveScanEnabled ? .on : .off)
        octiveCommand?.attributes = [.disabled]
        /// Resonance Command
        resonanceCommand = UICommand(title: CoreAstrology.CelestialEventType.menuItemTitle(.resonance(.harmonics(.global))),
                                     image: CoreAstrology.CelestialEventType.systemImage(.resonance(.harmonics(.global))),
                                     action: #selector(toggleResonanceScan(_:)),
                                     state: CelestialEventScanner.Core.resonanceScanEnabled ? .on : .off)
        resonanceCommand?.attributes = [.disabled]
        /// Update Menus
        updateMenus()
    }
    
    // Update Menus
    func updateMenus() {
        var menuCommands = [UICommand]()
        if let retrogradeCommand = retrogradeCommand { menuCommands.append(retrogradeCommand) }
        if let transitCommand = transitCommand { menuCommands.append(transitCommand) }
        if let aspectCommand = aspectCommand { menuCommands.append(aspectCommand) }
        if let formationCommand = formationCommand { menuCommands.append(formationCommand) }
        if let octiveCommand = octiveCommand { menuCommands.append(octiveCommand) }
        if let resonanceCommand = resonanceCommand { menuCommands.append(resonanceCommand) }
        
        let menu = UIMenu(title: "Sub Scanner Select", children: menuCommands)
        optionsMenuButton.menu = menu
    }
    
    // MARK: Scan Option Toggle Functions
    // Action methods for each command
    @objc func toggleRetrogradeScan(_ sender: UICommand) {
        DispatchQueue.main.async {
            CelestialEventScanner.Core.retrogradeScanEnabled.toggle()
            self.retrogradeCommand?.state = CelestialEventScanner.Core.retrogradeScanEnabled ? .on : .off
            self.updateMenus()
        }
    }
    // Transit Scan
    @objc func toggleTransitScan(_ sender: UICommand) {
        DispatchQueue.main.async {
            CelestialEventScanner.Core.transitScanEnabled.toggle()
            self.transitCommand?.state = CelestialEventScanner.Core.transitScanEnabled ? .on : .off
            self.updateMenus()
        }
    }
    // Aspect Scan Toggle
    @objc func toggleAspectScan(_ sender: UICommand) {
        DispatchQueue.main.async {
            CelestialEventScanner.Core.aspectScanEnabled.toggle()
            self.aspectCommand?.state = CelestialEventScanner.Core.aspectScanEnabled ? .on : .off
            self.updateMenus()
        }
    }
    // Formation Scan Toggle
    @objc func toggleFormationScan(_ sender: UICommand) {
        DispatchQueue.main.async {
            CelestialEventScanner.Core.formationScanEnabled.toggle()
            self.formationCommand?.state = CelestialEventScanner.Core.formationScanEnabled ? .on : .off
            self.updateMenus()
        }
    }
    // Octive Scan Toggle
    @objc func toggleOctiveScan(_ sender: UICommand) {
        DispatchQueue.main.async {
            CelestialEventScanner.Core.octiveScanEnabled.toggle()
            self.octiveCommand?.state = CelestialEventScanner.Core.octiveScanEnabled ? .on : .off
            self.updateMenus()
        }
    }
    // Resonance Scan Toggle
    @objc func toggleResonanceScan(_ sender: UICommand) {
        DispatchQueue.main.async {
            CelestialEventScanner.Core.resonanceScanEnabled.toggle()
            self.resonanceCommand?.state = CelestialEventScanner.Core.resonanceScanEnabled ? .on : .off
            self.updateMenus()
        }
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
            DispatchQueue.main.async {
                self.update()
            }
        }
    }
    // Select Button Action
    @IBAction func buttonSelect(_ sender: UIButton) {
        PlanetNodeAndAspectSelectViewController.presentModally(over: self, selectionContext: .scanner) {
            DispatchQueue.main.async {
                self.update()
            }
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
    
    // Scan Update (Main)
    func scanUpdate(progress: Float) {
        DispatchQueue.main.async {
            self.progressBar.progress = progress
            self.progressBar.isHidden = false
        }
    }
    // Scan Update (Sub)
    func subScanUpdate(progress: Float, type: CoreAstrology.CelestialEventType) {
        DispatchQueue.main.async {
            self.subProgressBar.progress = progress
            self.subProgressBar.isHidden = false
        }
    }
    // Scan Update (Deep)
    func deepScanUpdate(progress: Float, type: CoreAstrology.CelestialEventType) {
        DispatchQueue.main.async {
            self.deepScanProgressBar.progress = progress
            self.deepScanProgressBar.isHidden = false
        }
    }
    // Scan Complete (Main)
    func scanComplete(results: CelestialEventScanner.Results) {
        DispatchQueue.main.async {
            self.progressBar.progress = 0
            self.progressBar.isHidden = true
            self.buttonScan.isEnabled = true
        }
    }
    // Scan Complete (Sub)
    func subScanComplete(results: CelestialEventScanner.SubScanResults, type: CoreAstrology.CelestialEventType) {
        DispatchQueue.main.async {
            self.subProgressBar.progress = 0
            self.subProgressBar.isHidden = true
        }
    }
    // Scan Complete (Deep)
    func deepScanComplete(event: CoreAstrology.CelestialEvent, type: CoreAstrology.CelestialEventType) {
        DispatchQueue.main.async {
            self.deepScanProgressBar.progress = 0
            self.deepScanProgressBar.isHidden = true
        }
    }
    // Scan Error (Main)
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
    // Scan Error (Sub)
    func subScanError(error: CelestialEventScanner.ScanError) {
        switch error {
        default:
            DispatchQueue.main.async {
                self.progressBar.progress = 0
                self.subProgressBar.progress = 0
                self.buttonScan.isEnabled = true
            }
        }
    }
    // Scan Error (Deep)
    func deepScanError(error: CelestialEventScanner.ScanError) {
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
