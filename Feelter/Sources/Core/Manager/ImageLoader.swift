//
//  ImageLoader.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import UIKit

import Kingfisher

struct ImageLoader {
    static func applyAuthenticatedImage(
        at imageView: UIImageView,
        path: String
    ) {
        let tokenManager = DIContainer.shared.resolve(TokenManager.self)
        Task { @MainActor in
            let token = await tokenManager.accessToken
            let modifier = AnyModifier { request in
                var request = request
                request.addValue(
                    AppConfiguration.apiKey,
                    forHTTPHeaderField: "SeSACKey"
                )
                if let token = token {
                    request.addValue(token, forHTTPHeaderField: "Authorization")
                }
                return request
            }
            
            let url = "\(AppConfiguration.baseURL)/v1\(path)"
            
            imageView.kf.setImage(
                with: URL(string: url),
                options: [.requestModifier(modifier)]
            )
        }
    }
}
