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
    
    /// 값의 크기에 따라 적절한 정밀도로 포맷팅
    func formatByMagnitude() -> Double {
        let absoluteValue = abs(self)
        
        switch absoluteValue {
        case 100...:
            // 100 이상: 100의 자리까지만 (소수점 제거)
            return (self / 100).rounded() * 100
            
        case 10..<100:
            // 10 이상 100 미만: 소수점 1자리까지
            return (self * 10).rounded() / 10
            
        case 0..<10:
            // 1 이상 10 미만: 소수점 2자리까지
            return (self * 100).rounded() / 100
            
        default:
            // 0인 경우
            return 0
        }
    }
}
