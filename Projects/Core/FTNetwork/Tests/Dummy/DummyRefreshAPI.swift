//
//  DummyRefreshAPI.swift
//  FTNetworkTests
//
//  Created by 이정동 on 10/10/25.
//

import Foundation

import FTNetworkInterface

struct DummyRefreshAPI: APIEndpoint {
    var baseURL: URL { URL(string: "test")! }
    var path: String { "" }
    var method: HTTPMethod { .post }
    var task: HTTPTask { .requestPlain }
    var headers: [String : String]? { [:] }
}
