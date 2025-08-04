//
//  TokenInterceptor.swift
//  Feelter
//
//  Created by 이정동 on 8/4/25.
//

import Foundation

final class TokenInterceptor: RequestInterceptor {
    
    private let refreshCoordinator = RefreshCoordinator()
    private let keychainStorage: KeychainStorage
    
    // TODO: 동시성 문제 수정하기
    // (adapt 메서드 내부에서 읽기 동작과 동시에 retry 메서드에서 쓰기 동작이 이뤄질 수 있음)
    private var inMemoryAccessToken: String? {
        didSet {
            if let inMemoryAccessToken {
                try? keychainStorage.save(inMemoryAccessToken, forKey: .accessToken)
            } else {
                try? keychainStorage.delete(forKey: .accessToken)
            }
        }
    }
    
    private var inMemoryRefreshToken: String? {
        didSet {
            if let inMemoryRefreshToken {
                try? keychainStorage.save(inMemoryRefreshToken, forKey: .refreshToken)
            } else {
                try? keychainStorage.delete(forKey: .refreshToken)
            }
        }
    }
    
    init(keychainStorage: KeychainStorage) {
        self.keychainStorage = keychainStorage
        
        self.inMemoryAccessToken = try? keychainStorage.load(forKey: .accessToken)
        self.inMemoryRefreshToken = try? keychainStorage.load(forKey: .refreshToken)
    }
    
    // 요청 전에 액세스 토큰 추가
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        // 액세스 토큰이 존재하는지 확인 (없으면 엑세스 토큰을 설정할 필요 없는 API)
        guard let inMemoryAccessToken else { return request }
        
        var adaptedRequest = request
        adaptedRequest.setValue(
            inMemoryAccessToken,
            forHTTPHeaderField: "Authorization"
        )
        
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
        let refreshTask = await refreshCoordinator.refreshTask(performing: { [weak self] in
            guard let self else { return }
            let token = try await self.performAccessTokenRefresh(api: AuthAPI.refresh)
            
            // 새롭게 갱신된 액세스, 리프레시 토큰 저장
            self.inMemoryAccessToken = token.accessToken
            self.inMemoryRefreshToken = token.refreshToken
        })
        
        // 여러 요청이 동시에 같은 Task를 대기
        try await refreshTask.value
        
        // API 호출 재시도
        return .retry
    }
       
    // TODO: 리팩토링 필요
    private func performAccessTokenRefresh(api: APIEndpoint) async throws -> AuthTokenResponseDTO {
        
        guard var request = api.asURLRequest() else { throw HTTPResponseError.invalidAPI }
        request.setValue(inMemoryAccessToken, forHTTPHeaderField: "Authorization")
        request.setValue(inMemoryRefreshToken, forHTTPHeaderField: "RefreshToken")
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.urlSessionError(error)
        }
        
        // HTTP Response 코드 확인
        if let httpResponse = response as? HTTPURLResponse {
            guard 200...299 ~= httpResponse.statusCode else {
                // 액세스 토큰 갱신 실패 = 리프레스 토큰 만료
                // 키체인에 저장된 모든 토큰 제거
                inMemoryAccessToken = nil
                inMemoryRefreshToken = nil
                
                // TODO: 에러 타입 변경하기 (리프레시 토큰 만료)
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
