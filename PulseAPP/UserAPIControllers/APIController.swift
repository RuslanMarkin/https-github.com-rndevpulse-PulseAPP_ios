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
            let jsonDecoder = JSONDecoder()
            if let data = data, let userAvatar = try? jsonDecoder.decode(UserAvatar.self, from: data) {
                completion(.success(userAvatar))
            } else {
                completion(.failure(ErrorHandler.imageNotFound(400)))
            }
        }
        task.resume()
    }
    
    

//    var request = URLRequest.init(url: NSURL(string:
//        "http://127.0.0.1:7000/api/channels?filter=contributed")! as URL)
//
//
//
//    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
//        if (error != nil) {
//            print(error ?? "")
//        } else {
//            let httpResponse = response as? HTTPURLResponse
//            print(httpResponse ?? "")
//        }
//    })
    
}
