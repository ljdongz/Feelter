//
//  AuthRepository.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

protocol AuthRepository {
    
    func validationEmail(email: String) async throws
    func signUpWithEmail(_ form: SignUpForm) async throws
    
    func signInWithEmail(email: String, password: String) async throws
    func signInWithApple() async throws
    func signInWithKakao() async throws
}
