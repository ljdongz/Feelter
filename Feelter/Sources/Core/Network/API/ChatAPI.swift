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
    case uploadFiles(roomID: String, files: [UploadFileData])
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
        case let .uploadFiles(roomID, _):
            "/v1/chats/\(roomID)/files"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRoom: .post
        case .fetchRooms: .get
        case .sendMessage: .post
        case .fetchMessages: .get
        case .uploadFiles: .post
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
        case let .uploadFiles(_, files):
            let multiparts = files.map {
                MultipartFormData(
                    data: $0.data,
                    name: "files",
                    fileName: "file.\($0.extension.rawValue)",
                    mimeType: $0.extension.mimeType
                )
            }
            return .requestMultipartData(formData: multiparts)
        }
    }
    
    var headers: [String : String]? {
        [
            "SeSACKey": AppConfiguration.apiKey
        ]
    }
    
    
}
