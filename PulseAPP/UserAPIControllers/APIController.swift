//
//  APIController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import Foundation

class APIController {
    
    static let shared = APIController()
    
    let baseURL = URL(string: "http://192.168.1.100/api/v1")!
    
    func authentication(withlogin: String, password: String, completion: @escaping (AuthUserData?) -> Void){
        let authURL = baseURL.appendingPathComponent("auth")
        
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let data: [String: String] = ["login": withlogin, "password": password]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let userData = try? jsonDecoder.decode(AuthUserData.self, from: data) {
                completion(userData)
            } else {
                completion(nil)
                //print(error)
                //throw ErrorHandler.badRequest(<#T##Int#>, <#T##String#>)
            }
        }
        task.resume()
    }
    
    func registration(withlogin: String, password: String, telNumber: String, email: String, completion: @escaping (RegistrationUserData?) -> Void) {
        let regisURL = baseURL.appendingPathComponent("users/create")
        
        var request = URLRequest(url: regisURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: String] = ["pass": password, "phone": telNumber, "mail": email, "publicName": withlogin]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let regisData = try? jsonDecoder.decode(RegistrationUserData.self, from: data) {
                    completion(regisData)
                } else {
                    completion(nil)
                }
        }
        task.resume()
    }
    
}
