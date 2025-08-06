//
//  BannerAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

enum BannerAPI {
    case banners
}

extension BannerAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        "/v1/banners/main"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        .requestPlain
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SeSACKey": AppConfiguration.apiKey
        ]
    }
}
