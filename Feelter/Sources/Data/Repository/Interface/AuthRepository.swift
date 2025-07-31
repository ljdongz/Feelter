//
//  AuthRepository.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

protocol AuthRepository {
    func signInWithApple() async throws
    func signInWithKakao() async throws
}
