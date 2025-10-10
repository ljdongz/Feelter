//
//  NetworkProvider.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

public protocol NetworkProvider {
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        type: T.Type
    ) async throws -> T
    
    func request(endpoint: APIEndpoint) async throws
    
    func upload<T: Decodable>(
        endpoint: APIEndpoint,
        type: T.Type
    ) async throws -> T
}
