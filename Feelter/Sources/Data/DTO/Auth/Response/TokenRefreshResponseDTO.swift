//
//  AccessTokenRefreshResponseDTO.swift
//  Feelter
//
//  Created by 이정동 on 8/17/25.
//

import Foundation

struct TokenRefreshResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
