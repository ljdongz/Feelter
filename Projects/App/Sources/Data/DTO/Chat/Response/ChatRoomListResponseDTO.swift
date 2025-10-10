//
//  ChatRoomListResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatRoomListResponseDTO: Decodable {
    let rooms: [ChatRoomResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case rooms = "data"
    }
}
