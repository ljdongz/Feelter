//
//  CustomNumberFormatter.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

final class CustomNumberFormatter {
    static let shared = CustomNumberFormatter()
    
    private lazy var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func decimal(from number: Int) -> String {
        return decimalFormatter.string(from: NSNumber(value: number))!
    }
}
