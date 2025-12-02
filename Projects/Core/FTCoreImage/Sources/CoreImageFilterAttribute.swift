//
//  CoreImageFilterAttribute.swift
//  FTCoreImage
//
//  Created by 이정동 on 10/7/25.
//

import Foundation

public struct CoreImageFilterAttribute {
    /// 밝기 (-1.0 ~ 1.0)
    public var brightness: Double
    /// 노출 (-1.0 ~ 1.0)
    public var exposure: Double
    /// 대비 (-1.0 ~ 1.0)
    public var contrast: Double
    /// 채도 (0.0 ~ 2.0)
    public var saturation: Double
    /// 선명도 (-1.0 ~ 1.0) / 셰이더 스케일링 abs(sharpness) * 2.0
    public var sharpness: Double
    /// 블러 (-1.0 ~ 1.0) / 셰이더 스케일링 abs(blur) * 10.0
    public var blur: Double
    /// 비네팅 (-1.0 ~ 1.0) / 셰이더 스케일링 vignette * 2.0
    public var vignette: Double
    /// 노이즈 감소 (-1.0 ~ 1.0) / 셰이더 스케일링 noiseReduction * 0.02
    public var noiseReduction: Double
    /// 하이라이트 (-1.0 ~ 1.0) / 셰이더 스케일링 highlights + 1.0
    public var highlights: Double
    /// 그림자 (-1.0 ~ 1.0)
    public var shadows: Double
    /// 온도 (2000 ~ 10000) / 셰이더 스케일링 (temperature - 6500) / 4000
    public var temperature: Double
    /// 블랙 포인트 (-1.0 ~ 1.0)
    public var blackPoint: Double
}

public enum CoreImageFilterAttributeType {
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

public extension CoreImageFilterAttributeType {
    var filter: CoreImageFilter {
        switch self {
        case .brightness: CoreImageFilter.brightness
        case .exposure: CoreImageFilter.exposure
        case .contrast: CoreImageFilter.contrast
        case .saturation: CoreImageFilter.saturation
        case .sharpness: CoreImageFilter.sharpness
        case .blur: CoreImageFilter.blur
        case .vignette: CoreImageFilter.vignette
        case .noiseReduction: CoreImageFilter.noiseReduction
        case .highlights: CoreImageFilter.highlight
        case .shadows: CoreImageFilter.shadow
        case .temperature: CoreImageFilter.temperature
        // TODO: 블랙포인트 수정
        case .blackPoint: CoreImageFilter.brightness
        }
    }
    
    var priority: Int {
        switch self {
        case .temperature: return 0     // 색온도
        case .exposure: return 1        // 노출
        case .highlights: return 2      // 하이라이트
        case .shadows: return 3         // 그림자
        case .blackPoint: return 4      // 블랙 포인트
        case .brightness: return 5      // 밝기
        case .contrast: return 6        // 대비
        case .saturation: return 7      // 채도
        case .vignette: return 8        // 비네팅
        case .blur: return 9            // 블러
        case .sharpness: return 10      // 선명도
        case .noiseReduction: return 11 // 노이즈 감소
        }
    }
}
