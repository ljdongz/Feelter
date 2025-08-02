//
//  NetworkProviderImpl.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct NetworkProviderImpl: NetworkProvider {
  
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func request<T: Decodable>(endpoint: APIEndpoint, type: T.Type) async throws -> T {
    let data = try await requestData(endpoint: endpoint)
    do {
      let decodedData = try JSONDecoder().decode(T.self, from: data)
      return decodedData
    } catch {
        throw NetworkError.decodingError(error)
    }
  }
}

private extension NetworkProviderImpl {
  func requestData(endpoint: APIEndpoint) async throws -> Data {
    guard let request = endpoint.asURLRequest() else {
      throw NetworkError.invalidURL
    }
    
    do {
      let (data, response) = try await session.data(for: request)
      
      if let httpResponse = response as? HTTPURLResponse {
        guard 200...299 ~= httpResponse.statusCode else {
          throw NetworkError.httpStatusError(httpResponse.statusCode)
        }
      }
      
      return data
    } catch {
      throw NetworkError.urlSessionError(error)
    }
  }
}
