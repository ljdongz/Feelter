//
//  KakaoAuthServiceImpl.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

struct KakaoAuthServiceImpl: KakaoAuthService {
    
    typealias KakaoAuthCompletion = (OAuthToken?, Error?) -> Void
    
    func requestAuthorization() async throws -> KakaoAuthResult {
        return try await withCheckedThrowingContinuation { continuation in
            let completionHandler: KakaoAuthCompletion = { oauthToken, error in
                self.handleAuthResult(
                    oauthToken: oauthToken,
                    error: error,
                    continuation: continuation
                )
            }
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: completionHandler)
            } else {
                UserApi.shared.loginWithKakaoAccount(completion: completionHandler)
            }
        }
    }
}

private extension KakaoAuthServiceImpl {
    func handleAuthResult(
        oauthToken: OAuthToken?,
        error: Error?,
        continuation: CheckedContinuation<KakaoAuthResult, Error>
    ) {
        if let error {
            continuation.resume(throwing: KakaoAuthError.authenticationFailed(error))
        } else if let token = oauthToken {
            let result = KakaoAuthResult(
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                expiresIn: token.expiresIn,
                scope: token.scope
            )
            continuation.resume(returning: result)
        } else {
            continuation.resume(throwing: KakaoAuthError.invalidToken)
        }
    }
}
