//
//  Font+Ext.swift
//  Feelter
//
//  Created by 이정동 on 7/21/25.
//

import UIKit

extension UIFont {
    enum PretendardWeight: String, CaseIterable {
        case black = "Pretendard-Black"
        case extraBold = "Pretendard-ExtraBold"
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case light = "Pretendard-Light"
        case extraLight = "Pretendard-ExtraLight"
        case thin = "Pretendard-Thin"
    }
    
    enum HakgyoansimMulgyeol: String, CaseIterable {
        case regular = "TTHakgyoansimMulgyeolR"
        case bold = "TTHakgyoansimMulgyeolB"
    }
    
    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        return UIFont(name: weight.rawValue, size: size)!
    }
    
    static func hakgyoansimMulgyeol(size: CGFloat, weight: HakgyoansimMulgyeol) -> UIFont {
        return UIFont(name: weight.rawValue, size: size)!
    }
}
