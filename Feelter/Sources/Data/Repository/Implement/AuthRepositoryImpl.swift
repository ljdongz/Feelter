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
    private let networkProvider: NetworkProvider
    
    init(
        appleAuthService: AppleAuthService,
        kakaoAuthService: KakaoAuthService,
        networkProvider: NetworkProvider
    ) {
        self.appleAuthService = appleAuthService
        self.kakaoAuthService = kakaoAuthService
        self.networkProvider = networkProvider
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        let requestDTO = EmailSignInRequestDTO(
            email: email,
            password: password,
            deviceToken: nil
        )
        
        let response = try await networkProvider.request(
            endpoint: AuthAPI.emailLogin(requestDTO),
            type: SignInResponseDTO.self
        )
        
        // TODO: 토큰 저장
    }
    
    func signInWithApple() async throws {
        
        let appleAuthResult = try await appleAuthService.requestAuthorization()
        
        let requestDTO = AppleSignInRequestDTO(
            idToken: appleAuthResult.identityToken,
            deviceToken: nil,
            nickname: appleAuthResult.nickname
        )
        
        let response = try await networkProvider.request(
            endpoint: AuthAPI.appleLogin(requestDTO),
            type: SignInResponseDTO.self
        )
        
        // TODO: 토큰 저장
    }
    
    func signInWithKakao() async throws {
        
        let result = try await kakaoAuthService.requestAuthorization()
        
        let requestDTO = KakaoSignInRequestDTO(
            oauthToken: result.accessToken,
            deviceToken: nil
        )
        
        let response = try await networkProvider.request(
            endpoint: AuthAPI.kakaoLogin(requestDTO),
            type: SignInResponseDTO.self
        )
        
        // TODO: 토큰 저장
    }
    
    
}
