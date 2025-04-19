//
//  NetworkConfig.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation

struct NetworkConfig {
    static let baseURL = "http://172.30.1.78:3000"
    static let defaultHeaders = [
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
    ]
}
