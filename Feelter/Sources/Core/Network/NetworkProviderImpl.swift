//
//  NetworkProviderImpl.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct NetworkProviderImpl: NetworkProvider {
    
    private let session: URLSession
    private let tokenInterceptor: RequestInterceptor?
    
    init(
        session: URLSession = .shared,
        tokenInterceptor: RequestInterceptor? = nil
    ) {
        self.session = session
        self.tokenInterceptor = tokenInterceptor
    }
    
    func request<T: Decodable>(endpoint: APIEndpoint, type: T.Type) async throws -> T {
        // URLRequest 객체 생성
        guard var request = endpoint.asURLRequest() else {
            throw NetworkError.invalidURL
        }
        
        // 토큰 인터셉터를 설정한 경우, adapt 호출
        if let tokenInterceptor {
            request = try await tokenInterceptor.adapt(request)
        }
        
        do {
            // API 요청
            return try await performRequest(request: request, type: type)
        } catch  {
            // 토큰 인터셉터에 에러를 전달하여, 에러 상태에 따른 액세스 토큰 갱신 요청 처리
            if let tokenInterceptor,
               let retryRequest = try await tokenInterceptor.retry(request, for: error) {
                return try await performRequest(request: retryRequest, type: type)
            }
            
            throw error
        }
    }
}

private extension NetworkProviderImpl {
    
    func performRequest<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T {
        
        // URLSession 통신
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.urlSessionError(error)
        }
        
        // HTTP Response 코드 확인
        if let httpResponse = response as? HTTPURLResponse {
            guard 200...299 ~= httpResponse.statusCode else {
                throw mapStatusCodeToError(httpResponse.statusCode)
            }
        }
        
        // JSON 디코딩
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func mapStatusCodeToError(_ statusCode: Int) -> HTTPResponseError {
        switch statusCode {
        case 401: .invalidObject
        case 403: .forbidden
        case 419: .expiredAccessToken
        case 420: .invalidHeaderKey
        case 429: .overcallLimit
        case 444: .invalidAPI
        case 400..<500: .clientError(statusCode)
        case 500..<600: .serverError(statusCode)
        default: .unknownError(statusCode)
        }
    }
}
