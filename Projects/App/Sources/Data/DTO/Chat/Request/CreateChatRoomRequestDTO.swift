//
//  CreateChatRoomRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct CreateChatRoomRequestDTO: Encodable {
    let opponentID: String
    
    enum CodingKeys: String, CodingKey {
        case opponentID = "opponent_id"
    }
}
