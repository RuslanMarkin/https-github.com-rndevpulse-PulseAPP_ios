//
//  MarkerPoint.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 11.02.2022.
//

import Foundation

struct MarkerPoint: Codable {
    let id: String?
    let pulse: Int?
    let typeId: String?
    let latLon: [Double]?
    let categoriesId: [String]?
    let region: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case pulse = "pulse"
        case typeId = "typeId"
        case latLon = "latLon"
        case categoriesId = "categoriesId"
        case region = "region"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        pulse = try values.decodeIfPresent(Int.self, forKey: .pulse)
        typeId = try values.decodeIfPresent(String.self, forKey: .typeId)
        latLon = try values.decodeIfPresent([Double].self, forKey: .latLon)
        categoriesId = try values.decodeIfPresent([String].self, forKey: .categoriesId)
        region = try values.decodeIfPresent(String.self, forKey: .region)
    }
}

//class MPoint: MKAnnotation {
//    
//}
