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

extension FilterAttribute {
    static let zero = FilterAttribute(
        brightness: 0,
        exposure: 0,
        contrast: 0,
        saturation: 0,
        sharpness: 0,
        blur: 0,
        vignette: 0,
        noiseReduction: 0,
        highlights: 0,
        shadows: 0,
        temperature: 0,
        blackPoint: 0
    )
}
