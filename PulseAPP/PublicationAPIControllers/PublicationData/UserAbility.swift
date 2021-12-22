//
//  UserAbility.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 22.12.2021.
//

import Foundation

struct UserAbility: Codable {
    var userLike: Int?
    var canLike: Int?
    
    enum CodingKeys: String, CodingKey {

        case userLike = "userLike"
        case canLike = "canLike"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userLike = try values.decodeIfPresent(Int.self, forKey: .userLike)
        canLike = try values.decodeIfPresent(Int.self, forKey: .canLike)
    }
}
