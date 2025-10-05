//
//  SignInResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct AuthTokenResponseDTO: Decodable {
    let userID: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case accessToken
        case refreshToken
    }
    
    func toDomain() -> AuthToken {
        .init(
            userID: userID,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
