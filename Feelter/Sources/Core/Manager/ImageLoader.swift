//
//  ImageLoader.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import Kingfisher

enum ImageCachePolicy {
    case memoryOnly
    case diskCache(expiration: ExpirationConfig)
    
    enum ExpirationConfig {
        case todayFilter
        case banners
        case hotTrendsFilter
        case todayAuthor
        case chatMessageFile
        
        var value: Double {
            switch self {
            case .todayFilter: 86400
            case .banners: 86400 * 7
            case .hotTrendsFilter: 86400
            case .todayAuthor: 86400
            case .chatMessageFile: 86400 * 30
            }
        }
    }
    
    var kingfisherOptions: KingfisherOptionsInfoItem {
        switch self {
        case .memoryOnly:
            return .cacheMemoryOnly
        case .diskCache(let expiration):
            return .diskCacheExpiration(.seconds(expiration.value))
        }
    }
}

@MainActor
final class ImageLoader {
    
    static let shared = ImageLoader()
    
    @Dependency private var tokenManager: TokenManager

    private init() {
        ImageCache.default.cleanExpiredDiskCache()
        
        // 100MB (8GB 기준으로 약 10%)
//        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 200
        // 500MB
        ImageCache.default.diskStorage.config.sizeLimit = 1024 * 1024 * 500
        ImageCache.default.diskStorage.config.expiration = .days(30)
    }
    
    func applyAuthenticatedImage(
        for imageView: UIImageView,
        path: String,
        cachePolicy: ImageCachePolicy = .memoryOnly,
        failureImage: UIImage? = nil
    ) {
        if path.isEmpty {
            imageView.image = failureImage
            return
        }
        
        let token = tokenManager.accessToken
        let modifier = AnyModifier { request in
            var request = request
            request.addValue(
                AppConfiguration.apiKey,
                forHTTPHeaderField: "SeSACKey"
            )
            if let token = token {
                request.addValue(
                    token,
                    forHTTPHeaderField: "Authorization"
                )
            }
            return request
        }
        
        let url = "\(AppConfiguration.baseURL)/v1\(path)"
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.indicatorType = .activity
        
        let kingfisherOptions: KingfisherOptionsInfo = [
            .processor(processor),
            .requestModifier(modifier),
            .backgroundDecode,
            .scaleFactor(UIScreen.main.scale),
            .onFailureImage(failureImage),
            cachePolicy.kingfisherOptions,
        ]
                
        imageView.kf.setImage(
            with: URL(string: url),
            options: kingfisherOptions
        ) 
    }
    
    func cancelDownloadTask(for imageView: UIImageView) {
        imageView.kf.cancelDownloadTask()
    }
}
