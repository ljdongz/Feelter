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
    case diskCache(expiration: TimeInterval)
    
    enum ExpirationConfig {
        case todayFilter
        case banners
        case hotTrendsFilter
        case todayAuthor
        
        var value: Int {
            switch self {
            case .todayFilter: 86400
            case .banners: 86400 * 7
            case .hotTrendsFilter: 86400
            case .todayAuthor: 86400
            }
        }
    }
    
    var kingfisherOptions: KingfisherOptionsInfoItem {
        switch self {
        case .memoryOnly:
            return .cacheMemoryOnly
        case .diskCache(let expiration):
            return .diskCacheExpiration(.seconds(expiration))
        }
    }
}

@MainActor
final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}

    @Dependency private var tokenManager: TokenManager
    
    func applyAuthenticatedImage(
        for imageView: UIImageView,
        path: String,
        cachePolicy: ImageCachePolicy = .memoryOnly
    ) {
        if path.isEmpty {
            imageView.image = .sample
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
        
        var kingfisherOptions: KingfisherOptionsInfo = [
            .processor(processor),
            .requestModifier(modifier),
            .backgroundDecode,
            .scaleFactor(UIScreen.main.scale),
            .onFailureImage(.sample),
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
