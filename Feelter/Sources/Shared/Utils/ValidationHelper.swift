//
//  ValidationHelper.swift
//  Feelter
//
//  Created by Claude on 7/31/25.
//

import Foundation

// MARK: - Validation Result

enum ValidationResult: Equatable {
    case valid
    case invalid(message: String)
    
    var isValid: Bool {
        self == .valid
    }
}

// MARK: - Validation Helper

struct ValidationHelper {
    
    // MARK: - Email Validation
    
    static func validateEmail(_ email: String) -> ValidationResult {
        guard !email.isEmpty else {
            return .invalid(message: "이메일을 입력해주세요.")
        }
        
        guard isValidEmailFormat(email) else {
            return .invalid(message: "올바른 이메일 형식이 아닙니다.")
        }
        
        return .valid
    }
    
    private static func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Password Validation
    
    static func validatePassword(_ password: String) -> ValidationResult {
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
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialChar = password.range(of: "[@$!%*#?&]", options: .regularExpression) != nil
        
        return (hasUppercase || hasLowercase) && hasNumber && hasSpecialChar
    }
    
    // MARK: - Phone Number Validation
    
    static func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        guard !phoneNumber.isEmpty else {
            return .invalid(message: "전화번호를 입력해주세요.")
        }
        
        let phoneRegex = "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        guard phonePredicate.evaluate(with: phoneNumber) else {
            return .invalid(message: "올바른 전화번호 형식이 아닙니다.")
        }
        
        return .valid
    }
}
