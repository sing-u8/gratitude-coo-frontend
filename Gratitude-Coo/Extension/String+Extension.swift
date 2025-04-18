//
//  String+Extension.swift
//  Gratitude-Coo
//
//  Created by parksingyu on 4/18/25.
//

import Foundation

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
