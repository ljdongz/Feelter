//
//  UserAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

enum UserAPI {
    case todayAuthor
    case myProfile
}

extension UserAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: ftBaseURL)!
    }
    
    var path: String {
        switch self {
        case .todayAuthor:
            "/v1/users/today-author"
        case .myProfile:
            "/v1/users/me/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .todayAuthor: .get
        case .myProfile: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .todayAuthor:
                .requestPlain
        case .myProfile:
                .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
