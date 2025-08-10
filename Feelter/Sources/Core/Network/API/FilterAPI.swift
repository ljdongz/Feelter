//
//  FilterAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/6/25.
//

import Foundation

enum FilterAPI {
    case hotTrend
    case todayFilter
    case queryFilters(
        next: String?,
        limit: String?,
        category: String?,
        order: String?
    )
    case detail(filterID: String)
}

extension FilterAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        switch self {
        case .hotTrend:
            "/v1/filters/hot-trend"
        case .todayFilter:
            "/v1/filters/today-filter"
        case .queryFilters:
            "/v1/filters"
        case .detail(let id):
            "/v1/filters/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .hotTrend: .get
        case .todayFilter: .get
        case .queryFilters: .get
        case .detail: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
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
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SeSACKey": AppConfiguration.apiKey
        ]
    } 
}
