//
//  ChatMessage.swift
//  Feelter
//
//  Created by 이정동 on 8/14/25.
//

import Foundation

struct ChatMessage: Hashable {
    let chatID: String
    let roomID: String
    let content: String
    let fileURLs: [String]
    let sender: Profile
    let createdAt: String
    let updatedAt: String
}
