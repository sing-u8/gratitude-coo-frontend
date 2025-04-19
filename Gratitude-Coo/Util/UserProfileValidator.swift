//
//  UserProfileValidator.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/19/25.
//

import Foundation

struct UserProfileValidator {
    func validate(name: String, nickname: String) -> Bool {
        guard !name.isEmpty, !nickname.isEmpty else {
            return false
        }
        return isValidName(name) && isValidNickname(nickname)
    }
    
    private func isValidName(_ name: String) -> Bool {
        let nameRegex = ".{2,}"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        // 최소 8자, 최소 하나의 문자, 하나의 숫자, 하나의 특수문자
        let nicknameRegex = ".{2,}"
        let nicknamePredicate = NSPredicate(format:"SELF MATCHES %@", nicknameRegex)
        return nicknamePredicate.evaluate(with: nickname)
    }
}
