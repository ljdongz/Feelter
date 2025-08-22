//
//  PaymentAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/21/25.
//

import Foundation

enum PaymentAPI {
    case validation(Encodable)
    case inquiry(orderCode: String)
}

extension PaymentAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        switch self {
        case .validation:
            "/v1/payments/validation"
        case .inquiry(let orderCode):
            "/v1/payments/\(orderCode)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .validation: .post
        case .inquiry: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .validation(let data):
                .requestJSONEncodable(data)
        case .inquiry:
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
