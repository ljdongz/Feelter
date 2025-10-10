//
//  AppleAuthServiceImpl.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import AuthenticationServices
import Foundation
import UIKit


final class AppleAuthServiceImpl: NSObject, AppleAuthService {
    private var continuation: CheckedContinuation<AppleAuthResult, Error>?
    
    func requestAuthorization() async throws -> AppleAuthResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let appleProvider = ASAuthorizationAppleIDProvider()
            let request = appleProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension AppleAuthServiceImpl: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleAuthError.invalidCredential)
            continuation = nil
            return
        }
        
        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleAuthError.missingIdentityToken)
            continuation = nil
            return
        }
        
        let result = AppleAuthResult(
            identityToken: identityToken,
            nickname: credential.fullName?.givenName
        )
        
        continuation?.resume(returning: result)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

extension AppleAuthServiceImpl: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
