//
//  metadata.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 16.12.2021.
//

import Foundation

struct Metadata: Codable {
    let count: Int?
    let map: Int?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case map = "map"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        map = try values.decodeIfPresent(Int.self, forKey: .map)
    }
}
