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
    
    func validationEmail(email: String) async throws {
        let requestDTO = ValidationEmailRequestDTO(email: email)
        
        _ = try await networkProvider.request(
            endpoint: AuthAPI.validationEmail(requestDTO),
            type: ValidationEmailResponseDTO.self
        )
    }
    
    func signUpWithEmail(_ form: SignUpForm) async throws {
        let requestDTO = EmailSignUpRequestDTO(
            email: form.email,
            password: form.password,
            nickname: form.nickname,
            name: form.name,
            phoneNumber: form.phoneNumber,
            introduction: form.introduction,
            hashTags: form.hashTags,
            deviceToken: nil
        )
        
        let response = try await networkProvider.request(
            endpoint: AuthAPI.emailSignUp(requestDTO),
            type: AuthTokenResponseDTO.self
        )
        
        // TODO: 토큰 저장
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        let requestDTO = EmailSignInRequestDTO(
            email: email,
            password: password,
            deviceToken: nil
        )
        
        let response = try await networkProvider.request(
            endpoint: AuthAPI.emailLogin(requestDTO),
            type: AuthTokenResponseDTO.self
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
            type: AuthTokenResponseDTO.self
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
            type: AuthTokenResponseDTO.self
        )
        
        // TODO: 토큰 저장
    }
    
    
}
