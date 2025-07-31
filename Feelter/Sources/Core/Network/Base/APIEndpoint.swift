//
//  APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: [String: String]? { get }
}

extension APIEndpoint {
    func asURLRequest() -> URLRequest? {
        
        /// Full URL Path 설정
        guard var urlComponents = URLComponents(
            url: baseURL.appending(path: path),
            resolvingAgainstBaseURL: true
        ),
              let url = urlComponents.url else { return nil }
        
        /// URLRequest 객체 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? urlRequest.allHTTPHeaderFields
        
        /// 요청 작업 별 설정
        switch self.task {
        case .requestPlain:
            break
            
        case let .requestQueryParameters(parameter):
            let queryItems: [URLQueryItem] = parameter.compactMap {
                guard let value = $0.value as? String else { return nil }
                return URLQueryItem(name: $0.key, value: value)
            }
            urlComponents.queryItems = urlComponents.queryItems.map { $0 + queryItems } ?? queryItems
            urlRequest.url = urlComponents.url
        
        case let .requestJSONEncodable(parameters):
            urlRequest.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        return urlRequest
    }
}
