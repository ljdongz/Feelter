//
//  Float+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import Foundation

extension Float {
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
