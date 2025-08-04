//
//  TokenInterceptor.swift
//  Feelter
//
//  Created by 이정동 on 8/4/25.
//

import Foundation

final class TokenInterceptor: RequestInterceptor {
    
    private let refreshCoordinator = RefreshCoordinator()
    
    var dummyAccessToken = ""
    var dummyRefreshToken = ""
    
    // 요청 전에 액세스 토큰 추가
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        // TODO: 키체인에 액세스 토큰이 저장되었는지 확인 (없으면 엑세스 토큰을 설정할 필요 없는 API)
        
        var adaptedRequest = request
        
        // TODO: 액세스 토큰 가져와서 request 헤더에 추가
        adaptedRequest.setValue(dummyAccessToken, forHTTPHeaderField: "Authorization")
        
        return adaptedRequest
    }
    
    // 에러 발생 시 토큰 갱신 처리
    func retry(_ request: URLRequest, for error: Error) async throws -> RetryResult {
        guard let httpError = error as? HTTPResponseError,
              case .expiredAccessToken = httpError else {
            // 액세스 토큰 만료 에러가 아닌 경우, 재시도하지 않음
            return .doNotRetry
        }
        
        // 현재 진행중인 액세스 토큰 요청 작업을 가져옴 (만약 진행중인 작업이 없는 경우, 새로 생성)
        let refreshTask = await refreshCoordinator.refreshTask(performing: {
            let token = try await self.performTokenRefresh(api: AuthAPI.refresh)
            
            // 토큰 저장
            self.dummyAccessToken = token.accessToken
        })
        
        // 여러 요청이 동시에 같은 Task를 대기
        try await refreshTask.value
        
        // API 호출 재시도
        return .retry
    }
       
    // TODO: 리팩토링 필요
    private func performTokenRefresh(api: APIEndpoint) async throws -> AuthTokenResponseDTO {
        
        guard var request = api.asURLRequest() else { throw HTTPResponseError.invalidAPI }
        request.setValue(dummyRefreshToken, forHTTPHeaderField: "RefreshToken")
        request.setValue(dummyAccessToken, forHTTPHeaderField: "Authorization")
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.urlSessionError(error)
        }
        
        // HTTP Response 코드 확인
        if let httpResponse = response as? HTTPURLResponse {
            guard 200...299 ~= httpResponse.statusCode else {
                throw HTTPResponseError.clientError(httpResponse.statusCode)
            }
        }
        
        // JSON 디코딩
        do {
            return try JSONDecoder().decode(AuthTokenResponseDTO.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// 액세스 토큰 갱신 요청이 동시에 들어올 수 있기 때문에, 이에 대한 동시성 처리를 담당하는 Actor
fileprivate actor RefreshCoordinator {
    
    private var refreshTask: Task<Void, Error>?
    private var lastRefreshTime: Date?
    private let refreshCooldown: TimeInterval = 1.0 // 1초 쿨다운
    
    func refreshTask(
        performing operation: @escaping () async throws -> Void
    ) async -> Task<Void, Error> {
        
        // 기존 진행 중인 작업이 있으면 재사용
        if let existingTask = refreshTask {
            return existingTask
        }
        
        // 최근에 갱신했다면 불필요한 갱신 방지
        if let lastRefresh = lastRefreshTime,
           Date().timeIntervalSince(lastRefresh) < refreshCooldown {
            // 빈 Task 반환 (실제 갱신은 하지 않음)
            return Task { }
        }
        
        let newTask = Task {
            defer {
                refreshTask = nil
                lastRefreshTime = Date()
            }
            try await operation()
        }
        
        refreshTask = newTask
        return newTask
    }
}
