//
//  UploadImageResponseData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 25.11.2021.
//

import Foundation

struct UploadImageResponseData: Codable {
    var id: String
    var file: String
}

//At image delete server response to this class
struct ImageDeleteId: Codable {
    var id: String
}
