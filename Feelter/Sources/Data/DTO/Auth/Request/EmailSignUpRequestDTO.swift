//
//  EmailSignUpRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/1/25.
//

import Foundation

struct EmailSignUpRequestDTO: Encodable {
    let email: String
    let password: String
    let nickname: String
    let name: String?
    let phoneNumber: String?
    let introduction: String?
    let hashTags: [String]?
    let deviceToken: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case nickname = "nick"
        case name
        case phoneNumber = "phoneNum"
        case introduction
        case hashTags
    }
}
