//
//  EventUploadServer.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 06.12.2021.
//

import Foundation

struct EventServerUpload: Codable {
    var userId: String
    var name: String
    var description: String
    var geoposition: String
    var publicationCategories: [String]
    var publicationTypeId: String
    var files: [String]
    var begin: String
    var end: String
    var coverageRadius: Int
    var regionCode: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case name = "name"
        case description = "description"
        case geoposition = "geoposition"
        case publicationCategories = "publicationCategories"
        case publicationTypeId = "publicationTypeId"
        case files = "files"
        case begin = "begin"
        case end = "end"
        case coverageRadius = "CoverageRadius"
        case regionCode = "regionCode"
    }
}

struct EventServerResponse: Codable {
    var userId: String
    var postId: String
    var status: String
    var countFiles: Int
}
