//
//  MarkerPoints.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 11.02.2022.
//

import Foundation

//This struct is used for map points display in main mapTab
struct MarkerPoints: Codable {
    let metadata: Metadata?
    let points: [MarkerPoint]?
    
    enum CodingKeys: String, CodingKey {
        case metadata = "metadata"
        case points = "points"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        metadata = try values.decodeIfPresent(Metadata.self, forKey: .metadata)
        points = try values.decodeIfPresent([MarkerPoint].self, forKey: .points)
    }
}
