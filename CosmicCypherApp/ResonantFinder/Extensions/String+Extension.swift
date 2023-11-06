//
//  String+Extension.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/13/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation

// MARK: Remove SubString After Chartacter Index from Int
extension String {
    // Remove characters after index
    func stringRemovingAfter(index: Int) -> String {
        var str = String(self)
        str.removeSubrange(str.index(str.startIndex, offsetBy: index)..<str.endIndex)
        return str
    }
    
}

// MARK: To Double
extension String {
    // Convert a string to a double
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

// MARK: Reverse Words
extension String {
    // Return a string with Reversed Words
    func reverseWords() -> String {
        return String.reverseWords(self)
    }
    
    // Convert a string into another string with Reversed Words
    static func reverseWords(_ s: String) -> String {
        // Identify Words
        let pattern = "\\w+"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return s }

        // Find Words
        guard let fullRange = s.range(of: s) else { return s }
        let nsFullRange = NSRange(fullRange, in: s)
        let results = regex.matches(in: s, range: nsFullRange)
        
        // Reverse Words in String
        var reversedString = s
        for result in results {
            /// Get Range
            guard let range = Range(result.range, in: reversedString) else { continue }
            
            /// Word
            let word = reversedString[range]
            
            /// Reverse
            let reversedWord = String(word.reversed())
            reversedString.replaceSubrange(range, with: reversedWord)
        }
        
        // Return String
        return reversedString
    }
}
