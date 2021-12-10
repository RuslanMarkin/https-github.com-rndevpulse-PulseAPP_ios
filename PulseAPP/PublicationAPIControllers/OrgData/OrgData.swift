//
//  OrgData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 10.12.2021.
//

import Foundation

struct Organization: Codable {
    var name: String
    var description: String
    var geoposition: String
    var publicationCategories: [String]
    var publicationTypeId: String
    var files: [String]
    var regionCode: String
}

struct OrgServerResponse: Codable {
    var id: String
    var status: String
    var countFiles: Int
}
