//
//  APIController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 12.10.2021.
//

import Foundation
import UIKit

class APIController {
    
    static let shared = APIController()
    
    let baseURL = URL(string: "http://192.168.1.100/api/v1/")!
    
    func authentication(withlogin: String, password: String, completion: @escaping (Result<AuthUserData, Error>) -> Void){
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
            if let error = error {
                completion(.failure(error))
            } else {
                let jsonDecoder = JSONDecoder()
                if let data = data, let userData = try? jsonDecoder.decode(AuthUserData.self, from: data) {
                    completion(.success(userData))
                } else {
                    completion(.failure(ErrorHandler.badRequest(400, "Invalid login")))
                }
            }
        }
        task.resume()
    }
    
    func registration(withlogin: String, password: String, telNumber: String, email: String, completion: @escaping (Result<RegistrationUserData, Error>) -> Void) {
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
            if let error = error {
                completion(.failure(error))
            } else {
            let jsonDecoder = JSONDecoder()
            if let data = data, let regisData = try? jsonDecoder.decode(RegistrationUserData.self, from: data) {
                    completion(.success(regisData))
                    } else {
                    completion(.failure(ErrorHandler.badRequest(403, "Error request")))
                    }
            }
        }
        task.resume()
    }
    
    //Retrieves user's preview from server
    func getUserPreview(withid: String, completion: @escaping (Result<UserPreviewData, Error>) -> Void) {
        let getUserPreviewURL = baseURL.appendingPathComponent("users/preview")
        
        var request = URLRequest(url: getUserPreviewURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: String] = ["id": withid]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let jsonDecoder = JSONDecoder()
                if let data = data, let userPreviewData = try? jsonDecoder.decode(UserPreviewData.self, from: data)
                {
                    completion(.success(userPreviewData))
                } else {
                    completion(.failure(ErrorHandler.badRequest(400, "Bad request")))
                }
            }
        }
        task.resume()
    }
    
    //Retrieves photo's url of user's avatar by token
    func getUserAvatarURL(withToken: String, completion: @escaping (Result<UserAvatar, Error>) -> Void) {
        let avatarURL = baseURL.appendingPathComponent("users/avatar")
        
        var request = URLRequest(url: avatarURL)
        let headers = ["authorization": "Bearer \(withToken)"]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            let jsonDecoder = JSONDecoder()
            if let data = data, let userAvatar = try? jsonDecoder.decode(UserAvatar.self, from: data) {
                completion(.success(userAvatar))
            } else {
                completion(.failure(ErrorHandler.imageNotFound(400)))
            }
        }
        task.resume()
    }
    
    //User's activation via 6-digit verification code genererated on server-side
    func userVerification(withCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let initialURL = baseURL.appendingPathComponent("auth/activated")
        
        let query: [String: String] = ["code": "\(withCode)"]
        let verificationURL = initialURL.withQueries(query)!
        
        var request = URLRequest(url: verificationURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            //let jsonDecoder = JSONDecoder()
            if let data = data , let jsonData = String(data: data, encoding: .utf8)
                //try? jsonDecoder.decode(VerificationUserData.self, from: data)
            {
                print(jsonData)
                completion(.success(jsonData))
            } else {
                completion(.failure(ErrorHandler.badRequest(400, "Bad Request")))
            }
        }
        task.resume()
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
        resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
{ URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
