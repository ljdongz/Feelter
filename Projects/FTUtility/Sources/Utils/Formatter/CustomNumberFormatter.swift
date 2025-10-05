//
//  CustomNumberFormatter.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

public final class CustomNumberFormatter {
    public static let shared = CustomNumberFormatter()
    
    private lazy var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    public func decimal(from number: Int) -> String {
        return decimalFormatter.string(from: NSNumber(value: number))!
    }
}
