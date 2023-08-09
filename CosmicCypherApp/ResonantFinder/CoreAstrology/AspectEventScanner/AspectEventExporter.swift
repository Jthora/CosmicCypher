//
//  AspectEventExporter.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/29/23.
//

import Foundation
import UIKit

class AspectEventExporter {
    
    // MARK: References
    var scanner: AspectEventScanner? = nil
    var archive: AspectEventDataArchive? = nil
    
    // MARK: Properties
    var exportMode:ExportMode = .json
    var formatOption:AspectEventScanner.Results.Formatter.Option = .words
    var includeLegend:Bool = true
    var verbose:Bool = true
    
    var currentHashKey:AspectEventScanner.Results.HashKey? = nil
    
    // MARK: Export Cache
    var cache: [AspectEventScanner.Results.HashKey:ExportableData] = [:]
    var currentExportableData:ExportableData {
        if let hashKey = currentHashKey {
            if let exportableData = cache[hashKey] {
                return exportableData
            } else {
                let exportableData = AspectEventExporter.ExportableData.createEmpty()
                cache[exportableData.hashKey] = exportableData
                currentHashKey = exportableData.hashKey
                return exportableData
            }
        } else {
            let exportableData = AspectEventExporter.ExportableData.createEmpty()
            cache[exportableData.hashKey] = exportableData
            currentHashKey = exportableData.hashKey
            return exportableData
        }
    }
    func delete(for hashKey:AspectEventScanner.Results.HashKey) {
        cache.removeValue(forKey: hashKey)
    }
    
    
    // MARK: Share Data
    func exportData(_ exportableData:ExportableData? = nil,
                    vc:UIViewController,
                    sender: UIButton,
                    completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
        let exportableData = exportableData ?? currentExportableData
        
        guard !exportableData.dataString.isEmpty else {
            print("Error while saving backup: Data String Empty")
            completion(false, "No Data. Data string is Empty!")
            return
        }
        
        let fileName = exportableData.fileName
        let fileExtension = exportableData.exportMode.fileExtension

        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        do {
            try exportableData.dataString.write(to: fileURL, atomically: true, encoding: .utf8)
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

// MARK: ExportMode
extension AspectEventExporter {
    enum ExportMode: Int {
        case json
        case txt
        
        var fileExtension:String {
            switch self {
            case .json: return "json"
            case .txt: return "txt"
            }
        }
    }
}

// MARK: ExportableData
extension AspectEventExporter {
    struct ExportableData {
        let dataString:String
        let exportMode:ExportMode
        let formatOption:AspectEventScanner.Results.Formatter.Option
        let includeLegend:Bool
        let verbose:Bool
        let hashKey:String
        
        static func createEmpty() -> ExportableData {
            return ExportableData(results: AspectEventScanner.Results(data: [String : Any](),
                                                                      hashKey: AspectEventScanner.Results.HashKey.current),
                                  exportMode: .json,
                                  formatOption: .symbols,
                                  includeLegend: true,
                                  verbose: true)
        }
        
        var fileExtension:String {
            return exportMode.fileExtension
        }
        
        var fileName:String {
            return "CosmicCypher_AspectEvents-\(hashKey)-\(formatOption.fileText)\(includeLegend ? "-L" : "")\(verbose ? "-V" : "")"
        }
        
        init(results: AspectEventScanner.Results, exportMode: ExportMode, formatOption: AspectEventScanner.Results.Formatter.Option, includeLegend: Bool, verbose: Bool) {
            self.exportMode = exportMode
            self.formatOption = formatOption
            self.includeLegend = includeLegend
            self.verbose = verbose
            self.hashKey = results.hashKey
            
            let dataString = results.format(exportMode: exportMode,
                                            formatOption: formatOption,
                                            includeLegend: includeLegend,
                                            verbose: verbose)
            self.dataString = dataString
        }
        
        
    }
}
