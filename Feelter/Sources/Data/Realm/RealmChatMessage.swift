//
//  RealmChatMessage.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

final class RealmChatMessage: Object {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted(indexed: true) var roomID: String
    @Persisted var content: String
    @Persisted var fileURLs: List<String>
    @Persisted var sender: RealmMessageSender?
    @Persisted(indexed: true) var createdAt: Date
    @Persisted var updatedAt: Date
}
