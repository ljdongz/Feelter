//
//  AppleAuthService.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import AuthenticationServices
import Foundation

enum AppleAuthError: Error {
    case invalidCredential
    case missingIdentityToken
    case encodingFailed
}

struct AppleAuthResult {
    let identityToken: String
    let nickname: String?
}

protocol AppleAuthService {
    func requestAuthorization() async throws -> AppleAuthResult
}
