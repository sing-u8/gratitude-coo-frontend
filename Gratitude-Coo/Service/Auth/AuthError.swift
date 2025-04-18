//
//  AuthError.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation

enum AuthError: Error {
    case invalidCredentials
    case encodingError
    case networkError(NetworkError)
    case unknown
}
