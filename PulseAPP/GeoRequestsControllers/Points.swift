//
//  Point.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 16.12.2021.
//

import Foundation

struct Points: Codable {
    let metadata: Metadata?
    let points: [MapPoint]?
    
    enum CodingKeys: String, CodingKey {
        case metadata = "metadata"
        case points = "points"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        metadata = try values.decodeIfPresent(Metadata.self, forKey: .metadata)
        points = try values.decodeIfPresent([MapPoint].self, forKey: .points)
    }
}


