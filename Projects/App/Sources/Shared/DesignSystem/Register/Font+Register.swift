//
//  Font+Ext.swift
//  Feelter
//
//  Created by 이정동 on 7/21/25.
//

import UIKit

extension UIFont {
    enum PretendardWeight {
        case black
        case extraBold
        case bold
        case semiBold
        case medium
        case regular
        case light
        case extraLight
        case thin

        var fontConvertible: FeelterFontConvertible {
            switch self {
            case .black: return FeelterFontFamily.Pretendard.black
            case .extraBold: return FeelterFontFamily.Pretendard.extraBold
            case .bold: return FeelterFontFamily.Pretendard.bold
            case .semiBold: return FeelterFontFamily.Pretendard.semiBold
            case .medium: return FeelterFontFamily.Pretendard.medium
            case .regular: return FeelterFontFamily.Pretendard.regular
            case .light: return FeelterFontFamily.Pretendard.light
            case .extraLight: return FeelterFontFamily.Pretendard.extraLight
            case .thin: return FeelterFontFamily.Pretendard.thin
            }
        }
    }

    enum HakgyoansimMulgyeolWeight {
        case bold
        case regular

        var fontConvertible: FeelterFontConvertible {
            switch self {
            case .bold: return FeelterFontFamily.HakgyoansimMulgyeol.b
            case .regular: return FeelterFontFamily.HakgyoansimMulgyeol.r
            }
        }
    }

    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        return weight.fontConvertible.font(size: size)
    }

    static func hakgyoansimMulgyeol(size: CGFloat, weight: HakgyoansimMulgyeolWeight) -> UIFont {
        return weight.fontConvertible.font(size: size)
    }
}
