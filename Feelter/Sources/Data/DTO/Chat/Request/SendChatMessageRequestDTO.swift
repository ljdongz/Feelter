//
//  SendChatMessageRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct SendChatMessageRequestDTO: Encodable {
    let content: String
    let fileURLs: [String]
    
    enum CodingKeys: String, CodingKey {
        case content
        case fileURLs = "files"
    }
}
