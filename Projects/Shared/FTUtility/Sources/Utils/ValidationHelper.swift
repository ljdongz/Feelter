//
//  ValidationHelper.swift
//  Feelter
//
//  Created by Claude on 7/31/25.
//

import Foundation
import RegexBuilder

// MARK: - Validation Error

public enum ValidationError: Error {
    case invalidFormat
}

// MARK: - Validation Result

public enum ValidationResult: Equatable {
    case valid
    case invalid(message: String)
    
    public var isValid: Bool {
        self == .valid
    }
}

// MARK: - Validation Helper

public struct ValidationHelper {

    // MARK: - Email Validation

    private static let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

    public static func validateEmail(_ email: String) -> ValidationResult {
        guard !email.isEmpty else {
            return .invalid(message: "이메일을 입력해주세요.")
        }

        guard email.wholeMatch(of: emailRegex) != nil else {
            return .invalid(message: "올바른 이메일 형식이 아닙니다.")
        }

        return .valid
    }
    
    // MARK: - Password Validation

    private static let uppercaseRegex = /[A-Z]/
    private static let lowercaseRegex = /[a-z]/
    private static let numberRegex = /[0-9]/
    private static let specialCharRegex = /[@$!%*#?&]/

    public static func validatePassword(_ password: String) -> ValidationResult {
        guard !password.isEmpty else {
            return .invalid(message: "비밀번호를 입력해주세요.")
        }

        guard password.count >= 8 else {
            return .invalid(message: "비밀번호는 8자리 이상이어야 합니다.")
        }

        guard hasRequiredPasswordComplexity(password) else {
            return .invalid(message: "영문, 숫자, 특수문자(@$!%*#?&)를 각각 포함해야 합니다.")
        }

        return .valid
    }

    private static func hasRequiredPasswordComplexity(_ password: String) -> Bool {
        let hasUppercase = password.contains(uppercaseRegex)
        let hasLowercase = password.contains(lowercaseRegex)
        let hasNumber = password.contains(numberRegex)
        let hasSpecialChar = password.contains(specialCharRegex)

        return (hasUppercase || hasLowercase) && hasNumber && hasSpecialChar
    }
    
    // MARK: - Phone Number Validation

    private static let phoneRegex = /^01[0-9][0-9]{3,4}[0-9]{4}$/

    public static func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        guard !phoneNumber.isEmpty else {
            return .invalid(message: "전화번호를 입력해주세요.")
        }

        guard phoneNumber.wholeMatch(of: phoneRegex) != nil else {
            return .invalid(message: "올바른 전화번호 형식이 아닙니다.")
        }

        return .valid
    }
}
