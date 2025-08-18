//
//  RealmRoom.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

final class RealmChatRoom: Object {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var participants: List<RealmMessageSender>
    @Persisted var lastChat: RealmChatMessage?
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
}
