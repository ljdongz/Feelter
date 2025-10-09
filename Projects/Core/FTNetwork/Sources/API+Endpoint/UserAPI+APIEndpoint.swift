//
//  UserAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

import FTNetworkInterface

extension UserAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        switch self {
        case .todayAuthor:
            "/v1/users/today-author"
        case .myProfile:
            "/v1/users/me/profile"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .todayAuthor: .get
        case .myProfile: .get
        }
    }

    public var task: HTTPTask {
        switch self {
        case .todayAuthor:
                .requestPlain
        case .myProfile:
                .requestPlain
        }
    }

    public var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
