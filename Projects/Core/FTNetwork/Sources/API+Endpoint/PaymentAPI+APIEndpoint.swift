//
//  PaymentAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

import FTNetworkInterface

extension PaymentAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        switch self {
        case .validation:
            "/v1/payments/validation"
        case .inquiry(let orderCode):
            "/v1/payments/\(orderCode)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .validation: .post
        case .inquiry: .get
        }
    }

    public var task: HTTPTask {
        switch self {
        case .validation(let data):
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
