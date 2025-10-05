//
//  MessageSender.swift
//  Feelter
//
//  Created by 이정동 on 8/17/25.
//

import Foundation

struct MessageSender: Hashable {
    let userID: String
    let nickname: String
    let name: String?
    let profileImageURL: String?
}
