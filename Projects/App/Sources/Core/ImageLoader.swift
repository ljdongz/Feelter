//
//  ImageLoader.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import Kingfisher

// Core
import FTStorage
import FTStorageInterface
// Shared
import FTDependencies
import FTUtility

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

// TODO: DIContainer에 의존성 등록 후 사용하는 곳에서 resolve로 사용하기
@MainActor
final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var tokenManager: TokenManager
    
    @Dependency private var environment: EnvironmentProviding

    init(tokenManager: TokenManager = DefaultTokenManager.shared) {
        self.tokenManager = tokenManager
        
        ImageCache.default.cleanExpiredDiskCache()
        
        // 200MB
        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 200
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
        
        let downsamplingSize: CGSize
        if imageView.bounds.size != .zero {
            downsamplingSize = imageView.bounds.size
        } else {
            // bounds가 zero인 경우 기본 크기로 폴백하거나 layoutIfNeeded 후 재시도
            imageView.layoutIfNeeded()
            if imageView.bounds.size != .zero {
                downsamplingSize = imageView.bounds.size
            } else {
                // 기본 크기로 폴백 (너무 큰 이미지 방지)
                downsamplingSize = CGSize(width: 200, height: 200)
            }
        }
        
        let token = tokenManager.accessToken
        let apiKey = environment.apiKey
        let modifier = AnyModifier { request in
            var request = request
            request.addValue(
                apiKey,
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
        
        let url = "\(environment.baseURL)/v1\(path)"
        let processor = DownsamplingImageProcessor(size: downsamplingSize)
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
