//
//  SignInValidator.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation

struct SignInValidator {
    func validate(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            return false
        }
        return isValidEmail(email) && isValidPassword(password)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[^@]+@[^@]+\\.[a-zA-Z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        // 최소 8자, 최소 하나의 문자, 하나의 숫자, 하나의 특수문자
        let passwordRegex = ".{6,}"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
