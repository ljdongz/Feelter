//
//  NetworkError.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case urlSessionError(Error)
    case decodingError(Error)
}

enum HTTPResponseError: Error {
    case invalidToken // 401
    case forbidden // 403
    case expiredAccessToken // 419
    case invalidHeaderKey // 420
    case overcallLimit // 429
    case invalidAPI // 444
    
    case clientError(Int)
    
    case serverError(Int)
    
    case unknownError(Int)
}
