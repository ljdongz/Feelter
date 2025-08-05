//
//  NetworkError.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

enum NetworkError: Error {
    case urlSessionError(Error)
    case notCreatedURLRequest
    case decodingError(Error)
}

enum HTTPResponseError: Error {
    /// 401 (액세스, 리프래시, 계정 불일치 등의 오류)
    case invalidObject

    /// 403 (갱신되기 이전 토큰 사용)
    case forbidden
    
    /// 419 (액세스 토큰 만료)
    case expiredAccessToken
    
    /// 420 (유효하지 않은 헤더 키)
    case invalidHeaderKey
    
    /// 429 (과호출)
    case overcallLimit
    
    /// 444 (비정상 API 호출0
    case invalidAPI
    
    case clientError(Int)
    case serverError(Int)
    case unknownError(Int)
}
