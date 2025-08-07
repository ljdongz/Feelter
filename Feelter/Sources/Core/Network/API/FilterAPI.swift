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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .hotTrend: .get
        case .todayFilter: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .hotTrend:
                .requestPlain
        case .todayFilter:
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
