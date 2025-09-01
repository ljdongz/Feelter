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
    private let tokenManager: TokenManager
    
    init(
        appleAuthService: AppleAuthService,
        kakaoAuthService: KakaoAuthService,
        networkProvider: NetworkProvider,
        tokenManager: TokenManager
    ) {
        self.appleAuthService = appleAuthService
        self.kakaoAuthService = kakaoAuthService
        self.networkProvider = networkProvider
        self.tokenManager = tokenManager
    }
    
    func validationEmail(email: String) async throws {
        let requestDTO = ValidationEmailRequestDTO(email: email)
        
        do {
            _ = try await networkProvider.request(
                endpoint: AuthAPI.validationEmail(requestDTO),
                type: ValidationEmailResponseDTO.self
            )
        } catch {
            try handleAuthError(error)
        }
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
            deviceToken: tokenManager.deviceToken
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.emailSignUp(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            updateToken(response)
            
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        let requestDTO = EmailSignInRequestDTO(
            email: email,
            password: password,
            deviceToken: tokenManager.deviceToken
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.emailLogin(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            updateToken(response)
            
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signInWithApple() async throws {
        
        let appleAuthResult = try await appleAuthService.requestAuthorization()
        
        let requestDTO = AppleSignInRequestDTO(
            idToken: appleAuthResult.identityToken,
            deviceToken: tokenManager.deviceToken,
            nickname: appleAuthResult.nickname
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.appleLogin(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            updateToken(response)
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signInWithKakao() async throws {
        
        let result = try await kakaoAuthService.requestAuthorization()
        
        let requestDTO = KakaoSignInRequestDTO(
            oauthToken: result.accessToken,
            deviceToken: tokenManager.deviceToken
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.kakaoLogin(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            updateToken(response)
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signOut() async throws {
        defer { tokenManager.clearToken() }
        try await networkProvider.request(endpoint: AuthAPI.signOut)
    }
}

extension AuthRepositoryImpl {
    
    private func updateToken(_ token: AuthTokenResponseDTO) {
        tokenManager.updateAuthToken(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken
        )
        
        tokenManager.updateUserID(token.userID)
    }
    
    private func handleAuthError(_ error: Error) throws {
        switch error {
        case HTTPResponseError.clientError(let code):
            if code == 409 {
                throw AuthError.alreadyExist
            } else {
                throw error
            }
        default:
            throw error
        }
    }
}
