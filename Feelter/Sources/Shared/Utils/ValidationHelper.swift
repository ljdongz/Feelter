//
//  ValidationHelper.swift
//  Feelter
//
//  Created by Claude on 7/31/25.
//

import Foundation

// MARK: - Validation Result

enum ValidationResult: Equatable {
    case none
    case valid
    case invalid(message: String)
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid, .none:
            return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .valid, .none:
            return nil
        case .invalid(let message):
            return message
        }
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
    
    // MARK: - Password Confirmation
    
    static func validatePasswordConfirmation(password: String, confirmation: String) -> ValidationResult {
        guard !confirmation.isEmpty else {
            return .invalid(message: "비밀번호 확인을 입력해주세요.")
        }
        
        guard password == confirmation else {
            return .invalid(message: "비밀번호가 일치하지 않습니다.")
        }
        
        return .valid
    }
    
    // MARK: - General Text Validation
    
    static func validateRequired(_ text: String, fieldName: String) -> ValidationResult {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalid(message: "\(fieldName)을(를) 입력해주세요.")
        }
        
        return .valid
    }
    
    static func validateLength(_ text: String, min: Int, max: Int, fieldName: String) -> ValidationResult {
        let length = text.count
        
        guard length >= min else {
            return .invalid(message: "\(fieldName)은(는) \(min)자 이상이어야 합니다.")
        }
        
        guard length <= max else {
            return .invalid(message: "\(fieldName)은(는) \(max)자 이하여야 합니다.")
        }
        
        return .valid
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

// MARK: - Convenience Extensions

extension ValidationHelper {
    
    // 여러 검증을 한번에 수행
    static func validateMultiple(_ validations: [ValidationResult]) -> ValidationResult {
        for validation in validations {
            if case .invalid = validation {
                return validation
            }
        }
        return .valid
    }
    
    // 로그인 폼 전체 검증
    static func validateSignInForm(email: String, password: String) -> ValidationResult {
        let emailValidation = validateEmail(email)
        let passwordValidation = validateRequired(password, fieldName: "비밀번호")
        
        return validateMultiple([emailValidation, passwordValidation])
    }
    
    // 회원가입 폼 전체 검증
    static func validateSignUpForm(email: String, password: String, passwordConfirmation: String) -> ValidationResult {
        let emailValidation = validateEmail(email)
        let passwordValidation = validatePassword(password)
        let confirmationValidation = validatePasswordConfirmation(password: password, confirmation: passwordConfirmation)
        
        return validateMultiple([emailValidation, passwordValidation, confirmationValidation])
    }
}
