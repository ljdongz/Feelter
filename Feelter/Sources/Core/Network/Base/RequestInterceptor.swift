//
//  Interceptor.swift
//  Feelter
//
//  Created by 이정동 on 8/3/25.
//

import Foundation

enum RetryResult {
    case retry
    case doNotRetry
}

protocol RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest
    func retry(_ request: URLRequest, for error: Error) async throws -> RetryResult
}
