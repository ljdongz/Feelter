//
//  Interceptor.swift
//  Feelter
//
//  Created by 이정동 on 8/3/25.
//

import Foundation

protocol RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest
    func retry(_ request: URLRequest, for error: Error) async throws -> URLRequest?
}

final class TokenInterceptor: RequestInterceptor {
    private var isRefreshing = false
    private var refreshTask: Task<Void, Error>?
    
    // 요청 전에 액세스 토큰 추가
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var adaptedRequest = request
        
        // TODO: 액세스 토큰 가져와서 request 헤더에 추가
        
        return adaptedRequest
    }
    
    // 에러 발생 시 토큰 갱신 처리
    func retry(_ request: URLRequest, for error: Error) async throws -> URLRequest? {
        guard let httpError = error as? HTTPResponseError,
              case .expiredAccessToken = httpError else {
            return nil // 재시도하지 않음
        }
        
        // 토큰 갱신 중이면 대기
        if isRefreshing {
            try await refreshTask?.value
        } else {
            // 토큰 갱신 시작
            isRefreshing = true
            refreshTask = Task {
                do {
                    // TODO: 액세스 토큰 갱신 요청 + 갱신된 토큰 저장
                } catch {
                    isRefreshing = false
                    throw error
                }
                isRefreshing = false
            }
            try await refreshTask?.value
        }
        
        // 갱신된 토큰으로 요청 재구성
        return try await adapt(request)
    }
}
