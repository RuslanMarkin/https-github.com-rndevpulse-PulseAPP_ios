//
//  UserData.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import Foundation

//Data retrieved from authentication process
struct AuthUserData: Codable {
    static let tokenUpdatedNotification = Notification.Name("AuthUserData.tokenUpdated")
    
    static var shared = AuthUserData() {
        didSet {
            NotificationCenter.default.post(name: AuthUserData.tokenUpdatedNotification, object: nil)
            }
    }
    
    var accessToken: String
    let userId: String
    
    init(accessToken: String = "", userId: String = "") {
        self.userId = userId
        self.accessToken = accessToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userId = "userId"
    }
}

//Data retrieved from registration process
struct RegistrationUserData: Codable {
    let id: String
    let publicName: String
    let active: Int
    
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
    var data: String?
    var countPublications: Int
    var countUsersSubscription: Int
}

struct LoginPassword {
    static var shared = LoginPassword()
    
    var telNumber: String
    var password: String
    
    init(telNumber: String = "", password: String = "") {
        self.telNumber = telNumber
        self.password = password
    }
}

struct VerificationUserData: Codable {
    var publicname: String
    var userId: String
    var active: Int
}

struct UserAvatar: Codable {
    let url: String
}
