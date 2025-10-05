//
//  ChatMessageListResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatMessageListResponseDTO: Decodable {
    let messages: [ChatMessageResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case messages = "data"
    }
}
