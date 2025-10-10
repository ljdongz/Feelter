//
//  ChatAPI+APIEndpoint.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

import FTNetworkInterface

extension ChatAPI: APIEndpoint {
    public var baseURL: URL {
        URL(string: ftBaseURL)!
    }

    public var path: String {
        switch self {
        case .createRoom:
            "/v1/chats"
        case .fetchRooms:
            "/v1/chats"
        case let .sendMessage(id, _):
            "/v1/chats/\(id)"
        case let .fetchMessages(id, _):
            "/v1/chats/\(id)"
        case let .uploadFiles(roomID, _):
            "/v1/chats/\(roomID)/files"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .createRoom: .post
        case .fetchRooms: .get
        case .sendMessage: .post
        case .fetchMessages: .get
        case .uploadFiles: .post
        }
    }

    public var task: HTTPTask {
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
        case let .uploadFiles(_, files):
            let multiparts = files.map {
                MultipartFormData(
                    data: $0.data,
                    name: "files",
                    fileName: "file.\($0.extension)",
                    mimeType: $0.mimeType
                )
            }
            return .requestMultipartData(formData: multiparts)
        }
    }

    public var headers: [String : String]? {
        [
            "SeSACKey": ftApiKey
        ]
    }
}
