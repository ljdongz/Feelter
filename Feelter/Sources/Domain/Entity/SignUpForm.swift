//
//  SignUpForm.swift
//  Feelter
//
//  Created by 이정동 on 8/1/25.
//

import Foundation

struct SignUpForm {
    var email: String = ""
    var password: String = ""
    var nickname: String = ""
    var name: String?
    var phoneNumber: String?
    var introduction: String?
    var hashTags: [String] = []
}
