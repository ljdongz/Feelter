//
//  AuthAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

import FTNetworkInterface

extension AuthAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        switch self {
        case .refresh:
            "/v1/auth/refresh"
        case .validationEmail:
            "/v1/users/validation/email"
        case .emailSignUp:
            "/v1/users/join"
        case .emailLogin:
            "/v1/users/login"
        case .appleLogin:
            "/v1/users/login/apple"
        case .kakaoLogin:
            "/v1/users/login/kakao"
        case .updateDeviceToken:
            "/v1/users/deviceToken"
        case .signOut:
            "/v1/users/logout"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .refresh: .get
        case .validationEmail: .post
        case .emailSignUp: .post
        case .emailLogin: .post
        case .appleLogin: .post
        case .kakaoLogin: .post
        case .updateDeviceToken: .put
        case .signOut: .post
        }
    }

    public var task: HTTPTask {
        switch self {
        case .refresh:
                .requestPlain
        case .validationEmail(let data):
                .requestJSONEncodable(data)
        case .emailSignUp(let data):
                .requestJSONEncodable(data)
        case .emailLogin(let data):
                .requestJSONEncodable(data)
        case .appleLogin(let data):
                .requestJSONEncodable(data)
        case .kakaoLogin(let data):
                .requestJSONEncodable(data)
        case .updateDeviceToken(let data):
                .requestJSONEncodable(data)
        case .signOut:
                .requestPlain
        }
    }

    public var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
