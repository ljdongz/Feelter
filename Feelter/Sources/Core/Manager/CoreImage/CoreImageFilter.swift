//
//  CoreImageFilter.swift
//  Feelter
//
//  Created by 이정동 on 8/26/25.
//

import CoreImage

struct CoreImageFilter {
    let name: String
    let displayName: String
    let parameter: FilterParameter
    
    struct FilterParameter {
        let key: String
        let range: ClosedRange<Float>
        let defaultValue: Float
        let noEffectValue: Float
    }
}

extension CoreImageFilter {
    static let brightness = CoreImageFilter(
        name: "CIColorControls",
        displayName: "밝기",
        parameter: FilterParameter(
            key: kCIInputBrightnessKey,
            range: -1.0...1.0,
            defaultValue: 0.0,
            noEffectValue: 0.0
        )
    )
    static let contrast = CoreImageFilter(
        name: "CIColorControls",
        displayName: "대비",
        parameter: FilterParameter(
            key: kCIInputContrastKey,
            range: 0.25...4.0,
            defaultValue: 1.0,
            noEffectValue: 1.0
        )
    )
    static let saturation = CoreImageFilter(
        name: "CIColorControls",
        displayName: "채도",
        parameter: FilterParameter(
            key: kCIInputSaturationKey,
            range: 0.0...2.0,
            defaultValue: 1.0,
            noEffectValue: 1.0
        )
    )
    
    static let exposure = CoreImageFilter(
        name: "CIExposureAdjust",
        displayName: "노출",
        parameter: FilterParameter(
            key: kCIInputEVKey,
            range: -10.0...10.0,
            defaultValue: 0.0,
            noEffectValue: 0.0
        )
    )
    
    static let blur = CoreImageFilter(
        name: "CIGaussianBlur",
        displayName: "블러",
        parameter: FilterParameter(
            key: kCIInputRadiusKey,
            range: 0.0...50.0,
            defaultValue: 10.0,
            noEffectValue: 0.0
        )
    )
    
    static let sharpness = CoreImageFilter(
        name: "CISharpenLuminance",
        displayName: "선명도",
        parameter: FilterParameter(
            key: kCIInputSharpnessKey,
            range: 0.0...2.0,
            defaultValue: 0.4,
            noEffectValue: 0.0
        )
    )
    
    static let vignette = CoreImageFilter(
        name: "CIVignette",
        displayName: "비네트",
        parameter: FilterParameter(
            key: kCIInputIntensityKey,
            range: -1.0...1.0,
            defaultValue: 0.0,
            noEffectValue: 0.0
        )
    )
    
    static let shadow = CoreImageFilter(
        name: "CIHighlightShadowAdjust",
        displayName: "그림자",
        parameter: FilterParameter(
            key: "inputShadowAmount",
            range: -1.0...1.0,
            defaultValue: 0.0,
            noEffectValue: 0.0
        )
    )
    
    static let highlight = CoreImageFilter(
        name: "CIHighlightShadowAdjust",
        displayName: "하이라이트",
        parameter: FilterParameter(
            key: "inputHighlightAmount",
            range: 0.3...1.0,
            defaultValue: 1.0,
            noEffectValue: 1.0
        )
    )
    
    static let noiseReduction = CoreImageFilter(
        name: "CINoiseReduction",
        displayName: "노이즈 감소",
        parameter: FilterParameter(
            key: "inputNoiseLevel",
            range: 0.0...0.1,
            defaultValue: 0.02,
            noEffectValue: 0.0
        )
    )
    
    static let temperature = CoreImageFilter(
        name: "CIWhitePointAdjust",
        displayName: "온도",
        parameter: FilterParameter(
            key: "inputColor",
            range: 2000...10000,
            defaultValue: 6500,
            noEffectValue: 6500
        )
    )
    
    static let allFilters: [CoreImageFilter] = [
        .brightness,
        .contrast,
        .saturation,
        .exposure,
        .blur,
        .sharpness,
        .vignette,
        .shadow,
        .highlight,
        .noiseReduction,
        .temperature
    ]
}

