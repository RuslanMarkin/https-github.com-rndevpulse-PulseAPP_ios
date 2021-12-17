//
//  GeoData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.12.2021.
//

import Foundation

struct MapPoint: Codable {
    let id: String?
    let pulse: Int?
    let publicationType: PublicationType?
    let geoposition: [Double]?
    let publicationCategories: [PublicationCategories]?
    let adress: String?
    let name: String?
    let description: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case pulse = "pulse"
        case publicationType = "publicationType"
        case geoposition = "geoposition"
        case publicationCategories = "publicationCategories"
        case adress = "adress"
        case name = "name"
        case description = "description"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        pulse = try values.decodeIfPresent(Int.self, forKey: .pulse)
        publicationType = try values.decodeIfPresent(PublicationType.self, forKey: .publicationType)
        geoposition = try values.decodeIfPresent([Double].self, forKey: .geoposition)
        publicationCategories = try values.decodeIfPresent([PublicationCategories].self, forKey: .publicationCategories)
        adress = try values.decodeIfPresent(String.self, forKey: .adress)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }
}
