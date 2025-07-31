//
//  AuthRepositoryImpl.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct AuthRepositoryImpl: AuthRepository {
    
    private let appleAuthService: AppleAuthService
    private let kakaoAuthService: KakaoAuthService
    
    init(
        appleAuthService: AppleAuthService,
        kakaoAuthService: KakaoAuthService
    ) {
        self.appleAuthService = appleAuthService
        self.kakaoAuthService = kakaoAuthService
    }
    
    func signInWithApple(
        idToken: String,
        deviceToken: String?,
        nickname: String?
    ) async throws {
        do {
            let result = try await appleAuthService.requestAuthorization()
            
            // TODO: 서버로 토큰 전송
        } catch {
            
        }
    }
    
    func signInWithKakao(
        oauthToken: String,
        deviceToken: String?
    ) async throws {
        do {
            let result = try await kakaoAuthService.requestAuthorization()
            
            // TODO: 서버로 토큰 전송
        } catch {
            
        }
    }
    
    
}
