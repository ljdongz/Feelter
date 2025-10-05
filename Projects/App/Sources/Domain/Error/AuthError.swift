//
//  AuthError.swift
//  Feelter
//
//  Created by 이정동 on 8/3/25.
//

import Foundation

enum AuthError: Error {
    case expiredRefreshToken
    
    case alreadyExist
}
