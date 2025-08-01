//
//  AuthAPI.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

enum AuthAPI {
    case refresh
    
    case validationEmail(Encodable)
    
    case emailLogin(Encodable)
    case appleLogin(Encodable)
    case kakaoLogin(Encodable)
}

extension AuthAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        switch self {
        case .refresh:
            "/v1/auth/refresh"
        case .validationEmail:
            "/v1/users/validation/email"
        case .emailLogin:
            "/v1/users/login"
        case .appleLogin:
            "/v1//users/login/apple"
        case .kakaoLogin:
            "/v1//users/login/kakao"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh: .get
        case .validationEmail: .post
        case .emailLogin: .post
        case .appleLogin: .post
        case .kakaoLogin: .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .refresh:
                .requestPlain
        case .validationEmail(let data):
                .requestJSONEncodable(data)
        case .emailLogin(let data):
                .requestJSONEncodable(data)
        case .appleLogin(let data):
                .requestJSONEncodable(data)
        case .kakaoLogin(let data):
                .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SeSACKey": AppConfiguration.apiKey
        ]
    }
}
