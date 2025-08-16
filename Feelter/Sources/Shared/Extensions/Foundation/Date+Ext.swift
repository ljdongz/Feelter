//
//  Date+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

extension Date {
    
    enum FormatType {
        case basic
        case fullDateWithWeekday
        case timeOnly
    }
    
    func formatted(_ format: FormatType) -> String {
        switch format {
        case .basic:
            CustomDateFormatter.shared.formatDate(self)
        case .fullDateWithWeekday:
            CustomDateFormatter.shared.formatFullDateWithWeekday(self)
        case .timeOnly:
            CustomDateFormatter.shared.formatTimeOnly(self)
        }
    }
}
