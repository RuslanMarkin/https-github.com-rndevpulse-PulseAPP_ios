//
//  RegionData.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 24.01.2022.
//

import Foundation

struct RegionData: Codable, Equatable {
    var type: String?
    var name: String?
    var code: String?
    var isChecked: Bool?
    
    enum Codingkeys: String, CodingKey {
        case type = "type"
        case name = "name"
        case code = "code"
    }
    
    static func ==(lhs: RegionData, rhs: RegionData) -> Bool {
        return lhs.code == rhs.code && lhs.name == rhs.name && lhs.type == rhs.type
    }
}
