//
//  MockURLSession.swift
//  FTNetworkTests
//
//  Created by Claude Code
//

import Foundation

import FTNetworkInterface

/// 테스트용 Mock URLSession
final class MockURLSession: URLSessionProtocol {

    // MARK: - Properties

    /// Actor를 사용한 Thread-safe 상태 관리
    private let state = MockURLSessionState()

    /// data 메서드 호출 시뮬레이션을 위한 지연 시간 (초)
    var delay: TimeInterval = 0

    // MARK: - Mock Response

    struct MockResponse {
        let data: Data
        let response: URLResponse

        init(data: Data, statusCode: Int, url: URL) {
            self.data = data
            self.response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )!
        }
    }

    // MARK: - URLSessionProtocol

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        // Actor를 통해 Thread-safe하게 카운터 증가
        await state.incrementCallCount()

        // 지연 시뮬레이션
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
        }

        // Actor를 통해 Thread-safe하게 응답 가져오기
        guard let mockResponse = await state.mockResponse else {
            throw MockError.noMockResponseConfigured
        }

        return (mockResponse.data, mockResponse.response)
    }

    // MARK: - Helper Methods

    /// 성공 응답 설정
    func setSuccessResponse(
        accessToken: String = "new-access-token",
        refreshToken: String = "new-refresh-token",
        statusCode: Int = 200,
        url: URL
    ) async {
        let json: [String: String] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]
        let data = try! JSONEncoder().encode(json)

        let response = MockResponse(
            data: data,
            statusCode: statusCode,
            url: url
        )

        await state.setMockResponse(response)
    }

    /// 실패 응답 설정
    func setFailureResponse(
        statusCode: Int = 419,
        url: URL
    ) async {
        let json: [String: String] = ["error": "Token refresh failed"]
        let data = try! JSONEncoder().encode(json)

        let response = MockResponse(
            data: data,
            statusCode: statusCode,
            url: url
        )

        await state.setMockResponse(response)
    }

    /// 초기화
    func reset() async {
        await state.reset()
        delay = 0
    }

    /// Thread-safe하게 카운터 가져오기
    func getDataCallCount() async -> Int {
        await state.dataCallCount
    }
    
    func upload(for: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        (Data(), URLResponse())
    }
}

// MARK: - MockURLSessionState Actor

/// MockURLSession의 상태를 Thread-safe하게 관리하는 Actor
private actor MockURLSessionState {
    var dataCallCount = 0
    var mockResponse: MockURLSession.MockResponse?

    func incrementCallCount() {
        dataCallCount += 1
    }

    func setMockResponse(_ response: MockURLSession.MockResponse) {
        mockResponse = response
    }

    func reset() {
        dataCallCount = 0
        mockResponse = nil
    }
}

// MARK: - Mock Error

enum MockError: Error {
    case noMockResponseConfigured
    case refreshFailed
}
