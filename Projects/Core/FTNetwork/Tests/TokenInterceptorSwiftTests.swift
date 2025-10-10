//
//  TokenInterceptorSwiftTests.swift
//  FTNetworkTests
//
//  Created by Claude Code
//

import Foundation
import Testing
@testable import FTNetwork

import FTDependencies
import FTNetworkInterface
import FTStorageInterface
import FTUtility

@Suite("TokenInterceptor Tests")
struct TokenInterceptorSwiftTests {

    var sut: TokenInterceptor
    var mockTokenManager: MockTokenManager
    var mockURLSession: MockURLSession

    init() async throws {
        mockTokenManager = MockTokenManager()
        mockURLSession = MockURLSession()

        sut = TokenInterceptor(
            tokenManager: mockTokenManager,
            urlSession: mockURLSession,
            refreshAPI: DummyRefreshAPI()
        )
    }

    // MARK: - Concurrent Retry Tests

    /// 동시에 여러 retry 요청이 들어왔을 때, 실제 네트워크 요청은 1번만 발생하는지 테스트
    @Test("동시에 5개 요청 시 네트워크 호출은 1번만 발생")
    func concurrentRetries_shouldPerformOnlyOneNetworkRequest() async throws {
        // Given: 5개의 동시 요청 준비
        let numberOfConcurrentRequests = 5
        let request = URLRequest.dummy
        let error = HTTPResponseError.expiredAccessToken

        // Mock 네트워크 응답 설정 (0.5초 지연으로 실제 네트워크 시뮬레이션)
        let refreshURL = URL(string: "https://test.com")!
        await mockURLSession.setSuccessResponse(
            accessToken: "refreshed-access-token",
            refreshToken: "refreshed-refresh-token",
            url: refreshURL
        )
        mockURLSession.delay = 0.5

        // When: 5개의 요청을 동시에 실행
        try await withThrowingTaskGroup(of: RetryResult.self) { group in
            for _ in 0..<numberOfConcurrentRequests {
                group.addTask {
                    try await self.sut.retry(request, for: error)
                }
            }

            // 모든 요청 완료 대기
            var results: [RetryResult] = []
            for try await result in group {
                results.append(result)
            }

            // Then: 모든 요청이 성공적으로 retry 되었는지 확인
            #expect(results.count == numberOfConcurrentRequests, "모든 요청이 완료되어야 합니다")
            #expect(results.allSatisfy { $0 == .retry }, "모든 요청이 retry 결과를 받아야 합니다")
        }

        // Then: 실제 네트워크 요청은 1번만 발생해야 함
        let networkCallCount = await mockURLSession.getDataCallCount()
        #expect(networkCallCount == 1, "네트워크 요청은 1번만 발생해야 합니다")

        // Then: 토큰 매니저의 updateAuthToken도 1번만 호출되어야 함
        let updateCallCount = mockTokenManager.getUpdateAuthTokenCallCount()
        #expect(updateCallCount == 1, "토큰 갱신은 1번만 호출되어야 합니다")

        // Then: 갱신된 토큰이 저장되었는지 확인
        #expect(mockTokenManager.accessToken == "refreshed-access-token")
        #expect(mockTokenManager.refreshToken == "refreshed-refresh-token")
    }

    /// 동시 요청들이 첫 번째 요청의 완료를 대기하는지 테스트
    @Test("동시 요청들이 첫 번째 요청 완료를 대기")
    func concurrentRetries_shouldWaitForFirstRequestCompletion() async throws {
        // Given
        let request = URLRequest.dummy
        let error = HTTPResponseError.expiredAccessToken

        actor CompletionOrderTracker {
            var order: [Int] = []
            func append(_ value: Int) {
                order.append(value)
            }
            func getOrder() -> [Int] {
                return order
            }
        }
        let orderTracker = CompletionOrderTracker()

        // 네트워크 요청에 충분한 지연 설정 (첫 번째 요청이 실행되는 동안 다른 요청들이 대기)
        let refreshURL = URL(string: "https://test.com")!
        await mockURLSession.setSuccessResponse(url: refreshURL)
        mockURLSession.delay = 1.0

        // When: 3개의 요청을 약간의 간격을 두고 실행
        let task1 = Task {
            let result = try await self.sut.retry(request, for: error)
            await orderTracker.append(1)
            return result
        }

        // 약간의 지연 후 두 번째, 세 번째 요청 시작 (첫 번째 요청이 진행 중일 때)
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1초

        let task2 = Task {
            let result = try await self.sut.retry(request, for: error)
            await orderTracker.append(2)
            return result
        }

        let task3 = Task {
            let result = try await self.sut.retry(request, for: error)
            await orderTracker.append(3)
            return result
        }

        // Then: 모든 요청 완료 대기
        let result1 = try await task1.value
        let result2 = try await task2.value
        let result3 = try await task3.value

        // 모든 요청이 성공
        #expect(result1 == .retry)
        #expect(result2 == .retry)
        #expect(result3 == .retry)

        // 완료 순서는 보장되지 않지만, 모두 완료되어야 함
        let completionOrder = await orderTracker.getOrder()
        #expect(completionOrder.count == 3, "3개의 요청이 모두 완료되어야 합니다")

        // 네트워크 요청은 1번만 발생
        let networkCallCount = await mockURLSession.getDataCallCount()
        #expect(networkCallCount == 1, "네트워크 요청은 1번만 발생해야 합니다")
    }

    /// 첫 번째 요청 실패 시 모든 대기 중인 요청도 실패하는지 테스트
    @Test("첫 번째 요청 실패 시 모든 요청 실패")
    func concurrentRetries_whenFirstFails_allShouldFail() async throws {
        // Given
        let request = URLRequest.dummy
        let error = HTTPResponseError.expiredAccessToken

        // 네트워크 실패 응답 설정 (419 상태 코드 = 리프레시 토큰 만료)
        let refreshURL = URL(string: "https://test.com")!
        await mockURLSession.setFailureResponse(statusCode: 419, url: refreshURL)
        mockURLSession.delay = 0.3

        actor ErrorCounter {
            var count = 0
            func increment() {
                count += 1
            }
            func getCount() -> Int {
                return count
            }
        }
        let errorCounter = ErrorCounter()

        // When: 3개의 동시 요청
        await withThrowingTaskGroup(of: RetryResult.self) { group in
            for _ in 0..<3 {
                group.addTask {
                    do {
                        return try await self.sut.retry(request, for: error)
                    } catch {
                        await errorCounter.increment()
                        throw error
                    }
                }
            }

            // 모든 요청이 실패해야 함
            do {
                for try await _ in group {
                    Issue.record("요청이 성공하면 안됩니다")
                }
            } catch {
                // 에러 발생 예상됨
            }
        }

        // Then: 모든 요청이 실패했는지 확인
        let errorCount = await errorCounter.getCount()
        #expect(errorCount == 3, "3개의 요청이 모두 실패해야 합니다")

        // Then: clearToken이 호출되었는지 확인 (리프레시 토큰 만료)
        #expect(mockTokenManager.clearTokenCalled, "토큰이 삭제되어야 합니다")

        // Then: 네트워크 요청은 1번만 발생
        let networkCallCount = await mockURLSession.getDataCallCount()
        #expect(networkCallCount == 1, "실패한 경우에도 네트워크 요청은 1번만 발생해야 합니다")
    }

    /// 비 expiredAccessToken 에러는 재시도하지 않는지 테스트
    @Test("토큰 에러가 아닌 경우 재시도하지 않음")
    func retry_withNonTokenError_shouldNotRetry() async throws {
        // Given
        let request = URLRequest.dummy
        let error = NetworkError.decodingError(NSError(domain: "test", code: 0))

        // When
        let result = try await sut.retry(request, for: error)

        // Then
        #expect(result == .doNotRetry, "토큰 에러가 아니면 재시도하지 않아야 합니다")

        // Then: 네트워크 요청이 발생하지 않았는지 확인
        let networkCallCount = await mockURLSession.getDataCallCount()
        #expect(networkCallCount == 0, "토큰 에러가 아니면 네트워크 요청이 발생하지 않아야 합니다")

        // Then: updateAuthToken이 호출되지 않았는지 확인
        let updateCallCount = mockTokenManager.getUpdateAuthTokenCallCount()
        #expect(updateCallCount == 0, "토큰 갱신이 호출되지 않아야 합니다")
    }

    /// 매우 많은 동시 요청 (스트레스 테스트)
    @Test("10개의 동시 요청에도 네트워크 호출은 1번만")
    func concurrentRetries_withManyRequests_shouldStillPerformOnlyOneNetworkRequest() async throws {
        // Given: 10개의 동시 요청
        let numberOfConcurrentRequests = 10
        let request = URLRequest.dummy
        let error = HTTPResponseError.expiredAccessToken

        let refreshURL = URL(string: "https://test.com")!
        await mockURLSession.setSuccessResponse(url: refreshURL)
        mockURLSession.delay = 0.5

        // When: 10개의 요청을 동시에 실행
        try await withThrowingTaskGroup(of: RetryResult.self) { group in
            for _ in 0..<numberOfConcurrentRequests {
                group.addTask {
                    try await self.sut.retry(request, for: error)
                }
            }

            var results: [RetryResult] = []
            for try await result in group {
                results.append(result)
            }

            // Then: 모든 요청이 성공
            #expect(results.count == numberOfConcurrentRequests)
            #expect(results.allSatisfy { $0 == .retry })
        }

        // Then: 네트워크 요청은 여전히 1번만
        let networkCallCount = await mockURLSession.getDataCallCount()
        #expect(networkCallCount == 1, "많은 동시 요청에도 네트워크 요청은 1번만 발생해야 합니다")
    }

    // MARK: - Adapt Tests

    @Test("토큰이 있는 경우 Authorization 헤더 추가")
    func adapt_withTokens_shouldAddAuthorizationHeader() {
        // Given
        mockTokenManager.accessToken = "test-access-token"
        mockTokenManager.refreshToken = "test-refresh-token"
        let request = URLRequest.dummy

        // When
        let adaptedRequest = sut.adapt(request)

        // Then
        #expect(
            adaptedRequest.value(forHTTPHeaderField: "Authorization") == "test-access-token",
            "Authorization 헤더가 추가되어야 합니다"
        )
    }

    @Test("토큰이 없는 경우 헤더를 추가하지 않음")
    func adapt_withoutTokens_shouldNotModifyRequest() {
        // Given
        mockTokenManager.accessToken = nil
        mockTokenManager.refreshToken = nil
        let request = URLRequest.dummy

        // When
        let adaptedRequest = sut.adapt(request)

        // Then
        #expect(
            adaptedRequest.value(forHTTPHeaderField: "Authorization") == nil,
            "토큰이 없으면 헤더가 추가되지 않아야 합니다"
        )
    }
}
