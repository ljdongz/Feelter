//
//  AuthRepository.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

protocol AuthRepository {
    func signInWithApple(
        idToken: String,
        deviceToken: String?,
        nickname: String?
    ) async throws
    
    func signInWithKakao(
        oauthToken: String,
        deviceToken: String?
    ) async throws
}
