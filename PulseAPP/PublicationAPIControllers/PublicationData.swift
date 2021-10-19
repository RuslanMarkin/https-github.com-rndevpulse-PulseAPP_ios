//
//  PublicationData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.10.2021.
//

import Foundation

struct Publication {
    var description: String
    var geoposition: String
    var publicationCategories: [String]
    var publicationTypeId: String
    var files: [String]
    var datePublication: String
}
