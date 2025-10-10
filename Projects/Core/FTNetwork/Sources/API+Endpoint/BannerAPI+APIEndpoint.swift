//
//  BannerAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

import FTNetworkInterface

extension BannerAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        "/v1/banners/main"
    }

    public var method: HTTPMethod {
        .get
    }

    public var task: HTTPTask {
        .requestPlain
    }

    public var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
