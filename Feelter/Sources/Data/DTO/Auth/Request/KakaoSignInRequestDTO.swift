//
//  KakaoSignInRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct KakaoSignInRequestDTO: Encodable {
    let oauthToken: String
    let deviceToken: String?
}
