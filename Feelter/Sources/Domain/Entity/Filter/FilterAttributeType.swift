//
//  FilterAttributeType.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import Foundation
import UIKit

enum FilterAttributeType: Hashable {
    /// 밝기 (-1.0 ~ 1.0)
    case brightness
    /// 노출 (-1.0 ~ 1.0)
    case exposure
    /// 대비 (-1.0 ~ 1.0)
    case contrast
    /// 채도 (0.0 ~ 2.0)
    case saturation
    /// 선명도 (-1.0 ~ 1.0) / 셰이더 스케일링 abs(sharpness) * 2.0
    case sharpness
    /// 블러 (-1.0 ~ 1.0) / 셰이더 스케일링 abs(blur) * 10.0
    case blur
    /// 비네팅 (-1.0 ~ 1.0) / 셰이더 스케일링 vignette * 2.0
    case vignette
    /// 노이즈 감소 (-1.0 ~ 1.0) / 셰이더 스케일링 noiseReduction * 0.02
    case noiseReduction
    /// 하이라이트 (-1.0 ~ 1.0) / 셰이더 스케일링 highlights + 1.0
    case highlights
    /// 그림자 (-1.0 ~ 1.0)
    case shadows
    /// 온도 (2000 ~ 10000) / 셰이더 스케일링 (temperature - 6500) / 4000
    case temperature
    /// 블랙 포인트 (-1.0 ~ 1.0)
    case blackPoint
}

extension FilterAttributeType {
    var image: UIImage {
        switch self {
        case .brightness: .brightness
        case .exposure: .exposure
        case .contrast: .contrast
        case .saturation: .saturation
        case .sharpness: .sharpness
        case .blur: .blur
        case .vignette: .vignette
        case .noiseReduction: .noise
        case .highlights: .highlights
        case .shadows: .shadows
        case .temperature: .temperature
        case .blackPoint: .blackPoint
        }
    }
}
