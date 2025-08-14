//
//  ChatRoom.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatRoom: Hashable {
    let roomID: String
    let participants: [Profile]
    let lastChat: ChatMessage?
    let createdAt: String
    let updatedAt: String
}

