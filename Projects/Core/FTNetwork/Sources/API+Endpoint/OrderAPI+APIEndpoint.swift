//
//  OrderAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

import FTNetworkInterface

extension OrderAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        switch self {
        case .create:
            "/v1/orders"
        case .inquiry:
            "/v1/orders"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .create: .post
        case .inquiry: .get
        }
    }

    public var task: HTTPTask {
        switch self {
        case .create(let data):
                .requestJSONEncodable(data)
        case .inquiry:
                .requestPlain
        }
    }

    public var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
