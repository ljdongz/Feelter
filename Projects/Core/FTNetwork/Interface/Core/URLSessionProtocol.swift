//
//  URLSessionProtocol.swift
//  FTNetworkInterface
//
//  Created by 이정동 on 10/9/25.
//

import Foundation

/// URLSession의 data 메서드를 추상화하는 프로토콜
public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func upload(for: URLRequest, from: Data) async throws -> (Data, URLResponse)
}

/// URLSession이 URLSessionProtocol을 준수하도록 확장
extension URLSession: URLSessionProtocol { }
