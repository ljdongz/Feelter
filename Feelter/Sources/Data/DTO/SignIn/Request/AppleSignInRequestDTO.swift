//
//  AppleSignInRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct AppleSignInRequestDTO: Encodable {
    let idToken: String
    let deviceToken: String?
    let nickname: String?
    
    enum CodingKeys: String, CodingKey {
        case idToken
        case deviceToken
        case nickname = "nick"
    }
}
