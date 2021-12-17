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
    var regionCode: String
    var attachTo: AttachTo? = nil
}

struct AttachTo: Codable {
    var id: String? = nil
    var typeId: String? = nil
}

struct PublicationServerResponse: Codable {
    var userId: String
    var postId: String
    var status: String
    var countFiles: Int
}
