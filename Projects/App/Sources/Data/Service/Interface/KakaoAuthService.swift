//
//  KakaoAuthService.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

import KakaoSDKAuth

enum KakaoAuthError: Error {
    case invalidToken
    case authenticationFailed(Error)
}

struct KakaoAuthResult {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval
    let scope: String?
}

protocol KakaoAuthService {
    @MainActor
    func requestAuthorization() async throws -> KakaoAuthResult
}
