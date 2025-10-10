//
//  CoreImageFilter.swift
//  Feelter
//
//  Created by 이정동 on 8/26/25.
//

import CoreImage

public struct CoreImageFilter {
    public let name: String
    public let displayName: String
    public let parameter: FilterParameter
    
    public struct FilterParameter {
        public enum ValueType {
            case number
            case vector
        }
        
        public let key: String
        public let range: ClosedRange<Double>
        public let defaultValue: Double
        public let valueType: ValueType
    }
}

public extension CoreImageFilter {
    static let brightness = CoreImageFilter(
        name: "CIColorControls",
        displayName: "밝기",
        parameter: FilterParameter(
            key: kCIInputBrightnessKey,
            range: -0.25...0.25, // default: -1.0...1.0
            defaultValue: 0.0,
            valueType: .number
        )
    )
    static let contrast = CoreImageFilter(
        name: "CIColorControls",
        displayName: "대비",
        parameter: FilterParameter(
            key: kCIInputContrastKey,
            range: 0.75...1.25, // default: 0.25...4.0
            defaultValue: 1.0,
            valueType: .number
        )
    )
    static let saturation = CoreImageFilter(
        name: "CIColorControls",
        displayName: "채도",
        parameter: FilterParameter(
            key: kCIInputSaturationKey,
            range: 0.0...2.0,
            defaultValue: 1.0,
            valueType: .number
        )
    )
    
    static let exposure = CoreImageFilter(
        name: "CIExposureAdjust",
        displayName: "노출",
        parameter: FilterParameter(
            key: kCIInputEVKey,
            range: -1.0...1.0, // default: -10.0...10.0
            defaultValue: 0.0,
            valueType: .number
        )
    )
    
    static let blur = CoreImageFilter(
        name: "CIGaussianBlur",
        displayName: "블러",
        parameter: FilterParameter(
            key: kCIInputRadiusKey,
            range: 0.0...10.0, // default: 0.0...50.0
            defaultValue: 0.0, // default: 10.0
            valueType: .number
        )
    )
    
    static let sharpness = CoreImageFilter(
        name: "CISharpenLuminance",
        displayName: "선명도",
        parameter: FilterParameter(
            key: kCIInputSharpnessKey,
            range: 0.0...2.0,
            defaultValue: 0.0, // default: 0.4
            valueType: .number
        )
    )
    
    static let vignette = CoreImageFilter(
        name: "CIVignette",
        displayName: "비네트",
        parameter: FilterParameter(
            key: kCIInputIntensityKey,
            range: -1.0...1.0,
            defaultValue: 0.0,
            valueType: .number
        )
    )
    
    static let shadow = CoreImageFilter(
        name: "CIHighlightShadowAdjust",
        displayName: "그림자",
        parameter: FilterParameter(
            key: "inputShadowAmount",
            range: -1.0...1.0,
            defaultValue: 0.0,
            valueType: .number
        )
    )
    
    static let highlight = CoreImageFilter(
        name: "CIHighlightShadowAdjust",
        displayName: "하이라이트",
        parameter: FilterParameter(
            key: "inputHighlightAmount",
            range: 0.3...1.0,
            defaultValue: 1.0,
            valueType: .number
        )
    )
    
    static let noiseReduction = CoreImageFilter(
        name: "CINoiseReduction",
        displayName: "노이즈 감소",
        parameter: FilterParameter(
            key: "inputNoiseLevel",
            range: 0.0...0.1,
            defaultValue: 0.0, // default: 0.02
            valueType: .number
        )
    )
    
    static let temperature = CoreImageFilter(
        name: "CITemperatureAndTint",
        displayName: "온도",
        parameter: FilterParameter(
            key: "inputNeutral",
            range: 3000...10000, // default: 2000...10000
            defaultValue: 6500,
            valueType: .vector
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

