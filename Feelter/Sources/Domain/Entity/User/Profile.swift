//
//  Profile.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct Profile: Hashable {
    let userID: String
    let email: String?
    let nickname: String
    let name: String?
    let introduction: String?
    let description: String?
    let profileImageURL: String?
    let phoneNumber: String?
    let hashTags: [String]
}
