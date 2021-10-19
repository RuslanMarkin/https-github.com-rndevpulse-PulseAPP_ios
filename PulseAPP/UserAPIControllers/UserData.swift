//
//  UserData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import Foundation

//Data retrieved from authentication process
struct AuthUserData: Codable {
    var accessToken: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userId = "userId"
    }
}

//Data retrieved from registration process
struct RegistrationUserData: Codable {
    let id: String
    let publicName: String
    let active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case publicName = "publicname"
        case active = "active"
    }
}

struct UserPreviewData: Codable {
    let id: String
    let publicName: String
    var name: String
    var data: String
    var countPublications: Int
    var countUsersSubscription: Int
}
