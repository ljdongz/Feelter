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
}
