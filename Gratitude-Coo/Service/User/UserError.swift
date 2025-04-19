//
//  UserError.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/19/25.
//

import Foundation

enum UserError: Error, Equatable {
    case invalidResponse
    case memberNotFound
    case unauthorized
    case networkError(NetworkError)
    case unknown(String)
    case notFound
    
    static func == (lhs: UserError, rhs: UserError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse),
             (.memberNotFound, .memberNotFound),
             (.unauthorized, .unauthorized),
             (.notFound, .notFound):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError == rhsError
        case (.unknown(let lhsMessage), .unknown(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("서버로부터 잘못된 응답을 받았습니다", comment: "Invalid response")
        case .memberNotFound:
            return NSLocalizedString("사용자를 찾을 수 없습니다", comment: "Member not found")
        case .unauthorized:
            return NSLocalizedString("인증되지 않은 접근입니다", comment: "Unauthorized access")
        case .networkError(let error):
            return error.localizedDescription
        case .unknown(let message):
            return NSLocalizedString(message, comment: "Unknown error")
        case .notFound:
            return NSLocalizedString("요청한 리소스를 찾을 수 없습니다", comment: "Resource not found")
        }
    }
    
    static func mapFromNetworkError(_ error: NetworkError) -> UserError {
        switch error {
        case .unauthorized:
            return .unauthorized
        default:
            return .networkError(error)
        }
    }
}

