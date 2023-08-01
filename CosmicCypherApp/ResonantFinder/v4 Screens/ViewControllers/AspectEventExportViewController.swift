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
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonBackup: UIButton!
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
        guard let results = currentResults else {
            textViewDataViewer.text = "No Scanner Results in Archive"
            buttonDelete.isEnabled = false
            buttonBackup.isEnabled = false
            buttonShare.isEnabled = false
            return
        }
        
        segmentedControlExportMode.selectedSegmentIndex = exporter.mode.rawValue
        textViewDataViewer.text = exporter.dataString
    }
    
    // MARK: Export Mode
    @IBAction func exportModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        guard let newMode = AspectEventExporter.ExportMode(rawValue: sender.selectedSegmentIndex) else {
            print("Index Out of Bounds: ExportMode Segmented Control")
            return
        }
        exporter.mode = newMode
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
        exporter.deleteData { success, errorMessage in
            if success {
                // Show success popup
                self.showPopup(title: "Backup Successful", message: "Data has been successfully backed up.")
            } else {
                // Show error popup with the error message
                let errorMessageToShow = errorMessage ?? "Unknown error occurred."
                self.showPopup(title: "Backup Error", message: errorMessageToShow)
            }
        }
    }
    
    // MARK: Backup
    @IBAction func backupButtonPressed(_ sender: UIButton) {
        exporter.backupData { success, errorMessage in
            if success {
                // Show success popup
                self.showPopup(title: "Backup Successful", message: "Data has been successfully backed up.")
            } else {
                // Show error popup with the error message
                let errorMessageToShow = errorMessage ?? "Unknown error occurred."
                self.showPopup(title: "Backup Error", message: errorMessageToShow)
            }
        }
    }
    
    // MARK: Share
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        exporter.shareData(vc: self, sender: sender) { success, errorMessage in
            if success {
                // Show success popup
                self.showPopup(title: "Share Successful", message: "Data has been successfully shared.")
            } else {
                // Show error popup with the error message
                let errorMessageToShow = errorMessage ?? "Unknown error occurred."
                self.showPopup(title: "Share Error", message: errorMessageToShow)
            }
        }
    }
    
    // MARK: Show Popup
    func showPopup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
