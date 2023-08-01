//
//  AspectEventExporter.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/29/23.
//

import Foundation
import UIKit

class AspectEventExporter {
    
    // MARK: Properties
    var mode:ExportMode = .json
    
    // References
    var scanner: AspectEventScanner? = nil
    var archive: AspectEventDataArchive? = nil
    
    var dataString:String {
        switch mode {
        case .json: return jsonDataString
        case .txt: return txtDataString
        case .symbols: return symbolDataString
        case .emoji: return emojiDataString
        }
    }
    var jsonDataString:String = ""
    var txtDataString:String = ""
    var symbolDataString:String = ""
    var emojiDataString:String = ""
    
    func process(results:AspectEventScanner.Results) {
        jsonDataString = results.format(.json)
        txtDataString = results.format(.txt)
        symbolDataString = results.format(.symbols)
        emojiDataString = results.format(.emoji)
    }
    
    func deleteData(completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        jsonDataString = ""
        txtDataString = ""
        symbolDataString = ""
        emojiDataString = ""
    }
    
    // MARK: Backup Data
    func backupData(completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
        guard !dataString.isEmpty else {
            print("Error while saving backup: Data String Empty")
            completion(false, "No Data. Data string is Empty!")
            return
        }
       
        // Create a unique filename based on the current timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.string(from: Date())
        let fileExtension = mode.fileExtension
        let fileName = "backup_\(dateString).\(fileExtension)"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName).appendingPathExtension(fileExtension)

            do {
                try dataString.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Backup successful!")
                completion(true, nil)
            } catch let error {
                print("Error while saving backup: \(error)")
                completion(false, error.localizedDescription)
            }
        }
    }
    
    // MARK: Share Data
    func shareData(vc:UIViewController, sender: UIButton, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
        
        guard !dataString.isEmpty else {
            print("Error while saving backup: Data String Empty")
            completion(false, "No Data. Data string is Empty!")
            return
        }
        
        let fileName = "shared_file"
        let fileExtension = mode.fileExtension

        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        do {
            try dataString.write(to: fileURL, atomically: true, encoding: .utf8)
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.excludedActivityTypes = []

            // Present the activity view controller
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.sourceView = sender
                popoverPresentationController.sourceRect = sender.bounds
            }

            vc.present(activityViewController, animated: true) {
                completion(true, nil) // Sharing completed successfully
            }
        } catch let error {
            print("Error while creating shared file: \(error)")
            completion(false, error.localizedDescription) // Sharing failed with an error
        }
    }
    
}

extension AspectEventExporter {
    enum ExportMode: Int {
        case json
        case txt
        case symbols
        case emoji
        
        var fileExtension:String {
            switch self {
            case .json: return "json"
            case .txt: return "txt"
            case .symbols: return "txt"
            case .emoji: return "txt"
            }
        }
    }
}
