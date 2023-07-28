//
//  DateFormatterManager.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/28.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    private init() { }
    
    func getTodyDate() -> String {
        let date = Date()
        
        return formatter.string(from: date)
    }
}
