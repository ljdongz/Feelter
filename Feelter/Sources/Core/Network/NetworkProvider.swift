//
//  NetworkProvider.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

protocol NetworkProvider {
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        type: T.Type
    ) async throws -> T
}
