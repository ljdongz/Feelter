//
//  EmailSignInRequestDTO.swift
//  Feelter
//
//  Created by 이정동 on 7/31/25.
//

import Foundation

struct EmailSignInRequestDTO: Encodable {
    let email: String
    let password: String
    let deviceToken: String?
}
