//
//  RealmMessageSender.swift
//  Feelter
//
//  Created by 이정동 on 8/18/25.
//

import Foundation

import RealmSwift

final class RealmMessageSender: Object {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var nickname: String
    @Persisted var name: String?
    @Persisted var profileImageURL: String?
    
    convenience init(
        userID: String,
        nickname: String,
        name: String? = nil,
        profileImageURL: String? = nil
    ) {
        self.init()
        self.userID = userID
        self.nickname = nickname
        self.name = name
        self.profileImageURL = profileImageURL
    }
    
    convenience init(from messageSender: MessageSender) {
        self.init()
        self.userID = messageSender.userID
        self.nickname = messageSender.nickname
        self.name = messageSender.name
        self.profileImageURL = messageSender.profileImageURL
    }
    
    func toDomain() -> MessageSender {
        .init(
            userID: userID,
            nickname: nickname,
            name: name,
            profileImageURL: profileImageURL
        )
    }
}
