//
//  SignInResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct SignInResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    
    func toDomain() -> AuthToken {
        .init(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
