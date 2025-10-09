//
//  APIEndpoint+Ext.swift
//  FTNetwork
//
//  Created by 이정동 on 10/9/25.
//

import Foundation

import FTNetworkInterface

extension APIEndpoint {
    func asURLRequest() -> URLRequest? {
        
        /// Full URL Path 설정
        guard var urlComponents = URLComponents(
            url: baseURL.appending(path: path),
            resolvingAgainstBaseURL: true
        ),
              let url = urlComponents.url else { return nil }
        
        /// URLRequest 객체 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? urlRequest.allHTTPHeaderFields
        
        /// 요청 작업 별 설정
        switch self.task {
        case .requestPlain:
            break
            
        case let .requestQueryParameters(parameter):
            let queryItems = parameter.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
            urlRequest.url = urlComponents.url
        
        case let .requestJSONEncodable(parameters):
            urlRequest.httpBody = try? JSONEncoder().encode(parameters)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case let .requestMultipartData(formData):
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = createMultipartBody(formData: formData, boundary: boundary)
        }
        
        return urlRequest
    }
    
    func createMultipartBody(formData: [MultipartFormData], boundary: String) -> Data {
        var body = Data()
        
        for data in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            if let fileName = data.fileName {
                body.append("Content-Disposition: form-data; name=\"\(data.name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            } else {
                body.append("Content-Disposition: form-data; name=\"\(data.name)\"\r\n".data(using: .utf8)!)
            }
            
            if let mimeType = data.mimeType {
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            }
            
            body.append(data.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
