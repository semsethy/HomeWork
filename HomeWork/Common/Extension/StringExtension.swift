//
//  DateExtension.swift
//  HomeWork
//
//  Created by JoshipTy on 13/8/25.
//

//
//  String+DateFormatting.swift
//  HomeWork
//
//  Created by JoshipTy on 13/8/25.
//

import Foundation

extension String {
    
    /// Converts a date string from multiple possible input formats to "dd/MM/yyyy HH:mm:ss".
    /// - Returns: Formatted date string, or the original string if parsing fails.
    func normalizedDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Phnom_Penh")
        
        // Possible input formats from API
        let possibleFormats = [
            "yyyy/MM/dd HH:mm:ss",
            "HH:mm:ss yyyy/MM/dd"
        ]
        
        for format in possibleFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                // Output in preferred format
                formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                return formatter.string(from: date)
            }
        }
        
        return self
    }
    
}
