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
            deviceToken: nil
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.emailSignUp(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            await tokenManager.updateToken(
                access: response.accessToken,
                refresh: response.refreshToken
            )
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        let requestDTO = EmailSignInRequestDTO(
            email: email,
            password: password,
            deviceToken: nil
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.emailLogin(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            await tokenManager.updateToken(
                access: response.accessToken,
                refresh: response.refreshToken
            )
            
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signInWithApple() async throws {
        
        let appleAuthResult = try await appleAuthService.requestAuthorization()
        
        let requestDTO = AppleSignInRequestDTO(
            idToken: appleAuthResult.identityToken,
            deviceToken: nil,
            nickname: appleAuthResult.nickname
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.appleLogin(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            await tokenManager.updateToken(
                access: response.accessToken,
                refresh: response.refreshToken
            )
        } catch {
            try handleAuthError(error)
        }
    }
    
    func signInWithKakao() async throws {
        
        let result = try await kakaoAuthService.requestAuthorization()
        
        let requestDTO = KakaoSignInRequestDTO(
            oauthToken: result.accessToken,
            deviceToken: nil
        )
        
        do {
            let response = try await networkProvider.request(
                endpoint: AuthAPI.kakaoLogin(requestDTO),
                type: AuthTokenResponseDTO.self
            )
            
            await tokenManager.updateToken(
                access: response.accessToken,
                refresh: response.refreshToken
            )
        } catch {
            try handleAuthError(error)
        }
    }
}

private extension AuthRepositoryImpl {
    func handleAuthError(_ error: Error) throws {
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
