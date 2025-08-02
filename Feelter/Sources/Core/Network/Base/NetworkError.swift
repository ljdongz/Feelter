//
//  NetworkError.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case httpStatusError(Int)
  case urlSessionError(Error)
  case decodingError(Error)
}
