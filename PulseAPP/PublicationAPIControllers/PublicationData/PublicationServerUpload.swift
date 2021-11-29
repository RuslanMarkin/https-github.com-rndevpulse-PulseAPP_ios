//
//  PublicationServerUpload.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 26.11.2021.
//

import Foundation

struct PublicationServerUpload: Codable {
    var userId: String
    var description: String
    var geoposition: String
    var publicationCategories: [String]
    var publicationTypeId: String
    var files: [String]
}


struct PublicationServerResponse: Codable {
    var userId: String
    var postId: String
    var status: String
    var countFiles: Int
}
