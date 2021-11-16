//
//  PublicationData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.10.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let publication = try? newJSONDecoder().decode(Publication.self, from: jsonData)

import Foundation

struct UsersPublications: Codable {
    let items: [UserPublication]
}





