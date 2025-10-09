//
//  ChatAPI.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

public enum ChatAPI {
    case createRoom(Encodable)
    case fetchRooms
    case sendMessage(roomID: String, Encodable)
    case fetchMessages(roomID: String, after: String?)
    case uploadFiles(roomID: String, files: [UploadFileData])
}

