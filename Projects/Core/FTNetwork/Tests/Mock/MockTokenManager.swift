//
//  MockTokenManager.swift
//  FTNetworkTests
//
//  Created by Claude Code
//

import Foundation

import FTStorageInterface

/// TokenManager의 Mock 구현체
/// 동시성 테스트를 위한 카운터와 콜백 기능 포함
final class MockTokenManager: TokenManager {

    // MARK: - TokenManager Properties

    var accessToken: String?
    var refreshToken: String?
    var deviceToken: String?
    var userID: String?

    // MARK: - Test Control Properties

    /// updateAuthToken 호출 횟수 추적
    private(set) var updateAuthTokenCallCount = 0

    /// clearToken 호출 여부
    private(set) var clearTokenCalled = false

    /// updateAuthToken이 호출될 때 실행될 콜백
    var onUpdateAuthToken: (() -> Void)?

    /// clearToken이 호출될 때 실행될 콜백
    var onClearToken: (() -> Void)?

    /// 토큰 갱신 시뮬레이션을 위한 지연 시간 (초)
    var refreshDelay: TimeInterval = 0

    /// 토큰 갱신 실패 시뮬레이션 여부
    var shouldRefreshFail = false

    /// Thread-safe한 카운터 접근을 위한 lock
    private let lock = NSLock()

    // MARK: - Initialization

    init(
        accessToken: String? = "mock-access-token",
        refreshToken: String? = "mock-refresh-token",
        deviceToken: String? = nil,
        userID: String? = nil
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.deviceToken = deviceToken
        self.userID = userID
    }

    // MARK: - TokenManager Methods

    func updateAuthToken(accessToken: String, refreshToken: String) {
        lock.lock()
        defer { lock.unlock() }

        updateAuthTokenCallCount += 1
        self.accessToken = accessToken
        self.refreshToken = refreshToken

        onUpdateAuthToken?()
    }

    func updateUserID(_ userID: String) {
        lock.lock()
        defer { lock.unlock() }

        self.userID = userID
    }

    func updateDeviceToken(_ deviceToken: String) {
        lock.lock()
        defer { lock.unlock() }

        self.deviceToken = deviceToken
    }

    func clearToken() {
        lock.lock()
        defer { lock.unlock() }

        clearTokenCalled = true
        accessToken = nil
        refreshToken = nil
        deviceToken = nil
        userID = nil

        onClearToken?()
    }

    // MARK: - Test Helper Methods

    /// 카운터와 플래그 초기화
    func reset() {
        lock.lock()
        defer { lock.unlock() }

        updateAuthTokenCallCount = 0
        clearTokenCalled = false
        onUpdateAuthToken = nil
        onClearToken = nil
        refreshDelay = 0
        shouldRefreshFail = false
    }

    /// 동시성 테스트를 위한 갱신 시뮬레이션
    /// - 지정된 지연 시간 후 토큰 갱신
    /// - shouldRefreshFail이 true면 에러 발생
    func simulateTokenRefresh() async throws {
        if refreshDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(refreshDelay * 1_000_000_000))
        }

        if shouldRefreshFail {
            throw MockError.refreshFailed
        }

        updateAuthToken(
            accessToken: "new-access-token-\(UUID().uuidString)",
            refreshToken: "new-refresh-token-\(UUID().uuidString)"
        )
    }

    /// Thread-safe하게 카운터 값 가져오기
    func getUpdateAuthTokenCallCount() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return updateAuthTokenCallCount
    }
}

