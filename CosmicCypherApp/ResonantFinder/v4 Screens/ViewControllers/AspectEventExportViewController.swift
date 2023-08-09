//
//  AspectEventExportViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/30/23.
//

import Foundation
import UIKit

class AspectEventExportViewController: UIViewController {
    
    // MARK: Modal Presentation
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "AspectEventExport", bundle: nil).instantiateViewController(withIdentifier: "AspectEventExportViewController") as? AspectEventExportViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var textViewDataViewer: UITextView!
    
    @IBOutlet weak var segmentedControlExportMode: UISegmentedControl!
    @IBOutlet weak var segmentedControlFormatOption: UISegmentedControl!
    
    @IBOutlet weak var switchIncludeLegend: UISwitch!
    @IBOutlet weak var switchVerbose: UISwitch!
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonArchives: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    
    // MARK: Helpers
    
    var exporter: AspectEventExporter = AspectEventScanner.Core.exporter
    var archive: AspectEventDataArchive = AspectEventScanner.Core.archive
    
    var currentResults:AspectEventScanner.Results? {
        guard let hashKey = archive.latestHashKey else { return nil }
        return archive.fetch(for: hashKey)
    }
    
    // MARK: UI Setup
    override func viewDidLoad() {
        updateUI()
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            guard let results = self.currentResults else {
                self.textViewDataViewer.text = "No Scanner Results in Archive"
                self.buttonDelete.isEnabled = false
                self.buttonArchives.isEnabled = false
                self.buttonShare.isEnabled = false
                return
            }
            
            let dataString = results.format(exportMode: self.exporter.exportMode,
                                            formatOption: self.exporter.formatOption,
                                            includeLegend: self.exporter.includeLegend,
                                            verbose: self.exporter.verbose)
            
            self.segmentedControlExportMode.selectedSegmentIndex = self.exporter.exportMode.rawValue
            self.textViewDataViewer.text = dataString
        }
    }
    
    // MARK: Export Mode
    @IBAction func exportModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        guard let newMode = AspectEventExporter.ExportMode(rawValue: sender.selectedSegmentIndex) else {
            print("Index Out of Bounds: ExportMode Segmented Control")
            return
        }
        self.exporter.exportMode = newMode
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    @IBAction func formatOptionSegmentedControlChanged(_ sender: UISegmentedControl) {
        guard let newOption = AspectEventScanner.Results.Formatter.Option(rawValue: sender.selectedSegmentIndex) else {
            print("Index Out of Bounds: FormatOption Segmented Control")
            return
        }
        self.exporter.formatOption = newOption
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    
    // MARK: Delete
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        showDeleteConfirmationAlert()
    }
    
    func showDeleteConfirmationAlert() {
        let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            // Perform the actual deletion logic here
            self?.performDelete()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func performDelete() {
        let hashKey = AspectEventScanner.Core.hashKey
        archive.delete(hashKey: hashKey)
        exporter.delete(for: hashKey)
    }
    
    // MARK: Share
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        exporter.exportData(vc: self,
                            sender: sender,
                            completion: { success, errorMessage in
            if success {
                // Show success popup
                self.showPopup(title: "Export Successful", message: "Data has been successfully shared.")
            } else {
                // Show error popup with the error message
                let errorMessageToShow = errorMessage ?? "Unknown error occurred."
                self.showPopup(title: "Export Error", message: errorMessageToShow)
            }
        })
    }
    
    // MARK: Show Popup
    func showPopup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
