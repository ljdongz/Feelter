//
//  OrderAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

enum OrderAPI {
    case create(Encodable)
    case inquiry
}

extension OrderAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        switch self {
        case .create:
            "/v1/orders"
        case .inquiry:
            "/v1/orders"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create: .post
        case .inquiry: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .create(let data):
                .requestJSONEncodable(data)
        case .inquiry:
                .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [
            "SeSACKey": AppConfiguration.apiKey
        ]
    }
}
