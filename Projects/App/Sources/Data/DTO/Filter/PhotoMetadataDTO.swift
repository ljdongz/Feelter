//
//  PhotoMetadataDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import Foundation

struct PhotoMetadataDTO: Codable {
    /// 카메라 정보
    let camera: String?
    /// 렌즈 정보
    let lens: String?
    /// 초점 거리
    let focalLength: Double?
    /// 조리개 값
    let aperture: Double?
    /// ISO
    let iso: Int?
    /// 셔터 속도
    let shutterSpeed: String?
    /// 해상도 너비
    let pixelWidth: Int?
    /// 해상도 높이
    let pixleHeight: Int?
    /// 파일 크기
    let fileSize: Int?
    /// 파일 포멧
    let format: String?
    /// 원본 촬영 날짜/시간
    let originDate: String?
    /// 위도
    let latitude: Double?
    /// 경도
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case camera
        case lens = "lens_info"
        case focalLength = "focal_length"
        case aperture
        case iso
        case shutterSpeed = "shutter_speed"
        case pixelWidth = "pixel_width"
        case pixleHeight = "pixel_height"
        case fileSize = "file_size"
        case format
        case originDate = "date_time_original"
        case latitude
        case longitude
    }
    
    func toDomain() -> PhotoMetadata {
        .init(
            camera: camera,
            lens: lens,
            focalLength: focalLength,
            aperture: aperture ,
            iso: iso,
            shutterSpeed: shutterSpeed,
            pixelWidth: pixelWidth,
            pixleHeight: pixleHeight,
            fileSize: fileSize,
            format: format,
            originDate: originDate,
            latitude: latitude,
            longitude: longitude
        )
    }
}
