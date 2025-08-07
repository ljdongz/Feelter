//
//  UserAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

enum UserAPI {
    case todayAuthor
}

extension UserAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        switch self {
        case .todayAuthor:
            "/v1/users/today-author"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .todayAuthor: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .todayAuthor:
                .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SeSACKey": AppConfiguration.apiKey
        ]
    }
}
