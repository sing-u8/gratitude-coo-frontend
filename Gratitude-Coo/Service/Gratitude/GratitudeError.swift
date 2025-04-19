import Foundation

enum GratitudeError: Error {
    case invalidInput
    case notFound
    case unauthorized
    case forbidden
    case serverError
    case unknown
    
    static func mapFromNetworkError(_ error: NetworkError) -> GratitudeError {
        switch error {
        case .badRequest:
            return .invalidInput
        case .notFound:
            return .notFound
        case .unauthorized:
            return .unauthorized
        case .forbidden:
            return .forbidden
        case .serverError:
            return .serverError
        default:
            return .unknown
        }
    }
} 