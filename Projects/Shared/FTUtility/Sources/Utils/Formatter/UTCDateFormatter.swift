//
//  UTCDateFormatter.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

public final class UTCDateFormatter {
    public static let shared = UTCDateFormatter()
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public func date(from string: String) -> Date? {
        return formatter.date(from: string)
    }
    
    public func string(from date: Date) -> String {
        return formatter.string(from: date)
    }
}
