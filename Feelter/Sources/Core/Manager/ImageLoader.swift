//
//  ImageLoader.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import Kingfisher

@MainActor
struct ImageLoader {

    @Dependency static private var tokenManager: TokenManager
    
    static func applyAuthenticatedImage(
        at imageView: UIImageView,
        path: String
    ) {
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
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: url),
            options: [
                .requestModifier(modifier),
                .backgroundDecode
            ]
        )
    }
    
    static func cancelDownloadTask(at imageView: UIImageView) {
        imageView.kf.cancelDownloadTask()
    }
}
