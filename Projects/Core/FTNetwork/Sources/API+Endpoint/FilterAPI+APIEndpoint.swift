//
//  FilterAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

import FTNetworkInterface

extension FilterAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        switch self {
        case .create:
            "/v1/filters"
        case .hotTrend:
            "/v1/filters/hot-trend"
        case .todayFilter:
            "/v1/filters/today-filter"
        case .queryFilters:
            "/v1/filters"
        case .detail(let id):
            "/v1/filters/\(id)"
        case let .like(id, _):
            "/v1/filters/\(id)/like"
        case .uploadFiles:
            "/v1/filters/files"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .create: .post
        case .hotTrend: .get
        case .todayFilter: .get
        case .queryFilters: .get
        case .detail: .get
        case .like: .post
        case .uploadFiles: .post
        }
    }

    public var task: HTTPTask {
        switch self {
        case let .create(data):
            return .requestJSONEncodable(data)
        case .hotTrend:
            return .requestPlain
        case .todayFilter:
            return .requestPlain
        case let .queryFilters(next, limit, category, order):
            var queryParameters: [String: Any] = [:]
            if let next { queryParameters["next"] = next }
            if let limit { queryParameters["limit"] = limit }
            if let category { queryParameters["category"] = category }
            if let order { queryParameters["order"] = order }
            return .requestQueryParameters(parameters: queryParameters)
        case .detail:
            return .requestPlain
        case let .like(_, body):
            return .requestJSONEncodable(body)
        case let .uploadFiles(original, filtered):
            return .requestMultipartData(formData: [
                .init(data: original, name: "files", fileName: "original.jpg", mimeType: "image/jpg"),
                .init(data: filtered, name: "files", fileName: "filtered.jpg", mimeType: "image/jpg")
            ])
        }
    }

    public var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
