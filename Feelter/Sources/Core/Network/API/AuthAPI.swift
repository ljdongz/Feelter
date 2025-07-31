//
//  AuthAPI.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

enum AuthAPI {
    case refresh
    
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
        case .appleLogin:
            "/v1//users/login/apple"
        case .kakaoLogin:
            "/v1//users/login/kakao"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh: .get
        case .appleLogin: .post
        case .kakaoLogin: .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .refresh:
                .requestPlain
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
