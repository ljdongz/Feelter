//
//  UIImage+Ext.swift
//  Feelter
//
//  Created by 이정동 on 8/25/25.
//

import UIKit
import ImageIO

public extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    // 비율 유지하면서 리사이즈 (옵션)
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let height = self.size.height * scale
        return resized(to: CGSize(width: width, height: height))
    }
    
    func resized(toHeight height: CGFloat) -> UIImage? {
        let scale = height / self.size.height
        let width = self.size.width * scale
        return resized(to: CGSize(width: width, height: height))
    }
    
    func jpegData(maxSizeInBytes: Int = 1024 * 1024) -> Data? {
        // 초기 압축 품질을 1.0에서 시작
        var compressionQuality: CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compressionQuality)

        // 이미지 데이터가 1MB보다 작거나 같으면 바로 반환
        if let data = imageData,
            data.count <= maxSizeInBytes {
            return data
        }

        // 1MB를 초과하는 경우 압축 품질을 0.1씩 줄여가며 압축
        while compressionQuality >= 0.1 {
            compressionQuality -= 0.1
            imageData = self.jpegData(compressionQuality: compressionQuality)

            if let data = imageData,
                data.count <= maxSizeInBytes {
                return data
            }
        }

        return imageData
    }

    /// ImageIO를 사용한 메모리 효율적인 다운샘플링
    /// - Parameter maxDimension: 최대 너비 또는 높이 (포인트 단위)
    /// - Returns: 다운샘플링된 이미지
    func downsampledImage(maxDimension: CGFloat) -> UIImage? {
        // UIImage를 Data로 변환
        guard let data = self.jpegData(compressionQuality: 1.0) ?? self.pngData() else {
            return nil
        }

        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }

        let maxDimensionInPixels = maxDimension * UIScreen.main.scale

        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary

        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        return UIImage(
            cgImage: downsampledImage,
            scale: UIScreen.main.scale,
            orientation: self.imageOrientation
        )
    }
}
