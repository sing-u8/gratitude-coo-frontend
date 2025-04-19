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
        case .invalidRequest, .invalidResponse:
            return .invalidInput
        case .httpError(let statusCode, _):
            switch statusCode {
            case 400:
                return .invalidInput
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 404:
                return .notFound
            case 500...599:
                return .serverError
            default:
                return .unknown
            }
        case .unauthorized:
            return .unauthorized
        case .decodingFailed, .requestFailed, .unknown:
            return .unknown
        }
    }
} 
