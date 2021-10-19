//
//  PublicationAPIController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 19.10.2021.
//

import Foundation

class PublicationAPIController {
    
    static let shared = PublicationAPIController()
    
    let baseURL = URL(string: "http://192.168.1.100/api/v1/")!
    
    func getUserSubscriptionsPublications(withUserId: String, withCoef: Int) {
        let subscriptionsURL = baseURL.appendingPathComponent("subscriptions/publications/\(withCoef)")
        
        var request = URLRequest(url: subscriptionsURL)
        request.httpMethod = "GET"
        
        let data: [String: String] = ["id": withUserId]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                <#body#>
//            }
            if let data = data {
                print(data)
            } else {
                print("Error")
            }
        }
        task.resume()
    }
}
