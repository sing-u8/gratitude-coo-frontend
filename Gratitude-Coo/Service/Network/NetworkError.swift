//
//  NetworkError.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidRequest
    case invalidResponse
    case requestFailed(Error)
    case httpError(statusCode: Int, data: Data)
    case decodingFailed(DecodingError)
    case unauthorized
    case unknown(Error)
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest, .invalidRequest),
             (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized):
            return true
        case (.requestFailed, .requestFailed):
            // requestFailed를 단순 비교 (Error는 Equatable이 아니므로)
            return true
        case (.httpError(let lhsCode, _), .httpError(let rhsCode, _)):
            return lhsCode == rhsCode
        case (.decodingFailed, .decodingFailed):
            // DecodingError도 Equatable이 아니므로 단순 비교
            return true
        case (.unknown, .unknown):
            // Error는 Equatable이 아니므로 단순 비교
            return true
        default:
            return false
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "잘못된 요청입니다. 다시 시도해주세요."
        case .invalidResponse:
            return "서버로부터 유효하지 않은 응답을 받았습니다."
        case .requestFailed(let error):
            return "네트워크 요청 실패: \(error.localizedDescription)"
        case .httpError(let statusCode, _):
            return "서버 오류 (코드: \(statusCode))"
        case .decodingFailed:
            return "데이터 디코딩 실패: 서버 응답 형식이 예상과 다릅니다."
        case .unauthorized:
            return "인증이 필요합니다. 다시 로그인해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
        }
    }
}
