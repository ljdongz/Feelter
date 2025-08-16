//
//  ChatAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

enum ChatAPI {
    case createRoom(Encodable)
    case fetchRooms
    case sendMessage(roomID: String, Encodable)
    case fetchMessages(roomID: String, after: String?)
}

extension ChatAPI: APIEndpoint {
    var baseURL: URL {
        URL(string: AppConfiguration.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createRoom:
            "/v1/chats"
        case .fetchRooms:
            "/v1/chats"
        case let .sendMessage(id, _):
            "/v1/chats/\(id)"
        case let .fetchMessages(id, _):
            "/v1/chats/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRoom: .post
        case .fetchRooms: .get
        case .sendMessage: .post
        case .fetchMessages: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createRoom(let encodable):
            return .requestJSONEncodable(encodable)
        case .fetchRooms:
            return .requestPlain
        case let .sendMessage(_, encodable):
            return .requestJSONEncodable(encodable)
        case let .fetchMessages(_, after):
            var queryParameters: [String: Any] = [:]
            if let after { queryParameters["next"] = after }
            return .requestQueryParameters(parameters: queryParameters)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SeSACKey": AppConfiguration.apiKey
        ]
    }
    
    
}
