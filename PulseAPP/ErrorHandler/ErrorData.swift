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
    var type: String
    var title: String
    var status: Int
    var traceId: String
    var errors: [String: [String]]
}
