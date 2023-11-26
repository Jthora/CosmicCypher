//
//  CelestialEventDataArchive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/30/23.
//

import Foundation

// MARK: CelestialEvent Data Archive
class CelestialEventDataArchive {
    
    var cache:[CelestialEventScanner.Results.HashKey:CelestialEventScanner.Results] = [:]
    var latestHashKey:CelestialEventScanner.Results.HashKey? = nil
    var latestResults:CelestialEventScanner.Results? {
        guard let latestHashKey = latestHashKey else { return nil }
        return cache[latestHashKey]
    }
    
    func store(results:CelestialEventScanner.Results) {
        cache[results.hashKey] = results
        latestHashKey = results.hashKey
    }
    
    func fetch(for hashKey:CelestialEventScanner.Results.HashKey) -> CelestialEventScanner.Results? {
        // Async extract data persistantly
        return cache[hashKey]
    }
    
    func delete(hashKey:CelestialEventScanner.Results.HashKey) {
        cache.removeValue(forKey: hashKey)
    }
    
    
    // MARK: Backup Data
    func backupData(_ exportableData:CelestialEventExporter.ExportableData,
                    completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        
        guard !exportableData.dataString.isEmpty else {
            print("Error while saving backup: Data String Empty")
            completion(false, "No Data. Data string is Empty!")
            return
        }
       
        // Create a unique filename based on the current timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let fileExtension = exportableData.exportMode.fileExtension
        let fileName = "backup_\(exportableData.fileName).\(fileExtension)"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName).appendingPathExtension(fileExtension)

            do {
                try exportableData.dataString.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Backup successful!")
                completion(true, nil)
            } catch let error {
                print("Error while saving backup: \(error)")
                completion(false, error.localizedDescription)
            }
        }
    }
}
