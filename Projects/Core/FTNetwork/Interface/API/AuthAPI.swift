//
//  AuthAPI.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

public enum AuthAPI {
    case refresh

    case validationEmail(Encodable)
    case emailSignUp(Encodable)

    case emailLogin(Encodable)
    case appleLogin(Encodable)
    case kakaoLogin(Encodable)

    case updateDeviceToken(Encodable)

    case signOut
}
