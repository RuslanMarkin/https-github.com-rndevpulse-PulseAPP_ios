//
//  ErrorData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 25.10.2021.
//

import Foundation

//{
//    "title": "title_error",
//    "code": code_error,
//    "detail": "detail_error"
//}

struct ErrorData: Codable, Error {
    var title: String
    var code: Int
    var detail: String
}
