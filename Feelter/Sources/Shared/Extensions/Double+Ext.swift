//
//  Double+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
