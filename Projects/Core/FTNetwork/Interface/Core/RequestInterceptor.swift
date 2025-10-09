//
//  Interceptor.swift
//  Feelter
//
//  Created by 이정동 on 8/3/25.
//

import Foundation

public enum RetryResult {
    case retry
    case doNotRetry
}

public protocol RequestInterceptor {
    func adapt(_ request: URLRequest) -> URLRequest
    func retry(_ request: URLRequest, for error: Error) async throws -> RetryResult
}
