//
//  FilterPreset.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import Foundation

struct FilterAttribute: Hashable {
    /// 밝기 (-1.0 ~ 1.0)
    var brightness: Double
    /// 노출 (-1.0 ~ 1.0)
    var exposure: Double
    /// 대비 (-1.0 ~ 1.0)
    var contrast: Double
    /// 채도 (0.0 ~ 2.0)
    var saturation: Double
    /// 선명도 (-1.0 ~ 1.0) / 셰이더 스케일링 abs(sharpness) * 2.0
    var sharpness: Double
    /// 블러 (-1.0 ~ 1.0) / 셰이더 스케일링 abs(blur) * 10.0
    var blur: Double
    /// 비네팅 (-1.0 ~ 1.0) / 셰이더 스케일링 vignette * 2.0
    var vignette: Double
    /// 노이즈 감소 (-1.0 ~ 1.0) / 셰이더 스케일링 noiseReduction * 0.02
    var noiseReduction: Double
    /// 하이라이트 (-1.0 ~ 1.0) / 셰이더 스케일링 highlights + 1.0
    var highlights: Double
    /// 그림자 (-1.0 ~ 1.0)
    var shadows: Double
    /// 온도 (2000 ~ 10000) / 셰이더 스케일링 (temperature - 6500) / 4000
    var temperature: Double
    /// 블랙 포인트 (-1.0 ~ 1.0)
    var blackPoint: Double
}

enum FilterAttributeType {
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
