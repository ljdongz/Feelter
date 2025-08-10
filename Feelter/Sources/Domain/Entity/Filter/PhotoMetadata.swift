//
//  PhotoMetadata.swift
//  Feelter
//
//  Created by 이정동 on 8/10/25.
//

import Foundation

struct PhotoMetadata: Hashable {
    /// 카메라 정보
    let camera: String?
    /// 렌즈 정보
    let lens: String?
    /// 초점 거리
    let focalLength: Float?
    /// 조리개 값
    let aperture: Float?
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
    let latitude: Float?
    /// 경도
    let longitude: Float?
}
