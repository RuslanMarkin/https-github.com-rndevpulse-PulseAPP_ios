//
//  ImageAPIController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.10.2021.
//

import Foundation
import UIKit

class ImageAPIController {
    
    static let shared = ImageAPIController()
    
    let baseURL = URL(string: "http://192.168.1.100/api/v1/")!
    
    func getUserAvatarImage(withUrl: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let avatarPhotoURL = baseURL.appendingPathComponent("files/\(withUrl)")
        
        var request = URLRequest(url: avatarPhotoURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            }
            else {
                completion(.failure(ErrorHandler.imageNotFound(401)))
            }
        }
        task.resume()
    }
    //Actually method above should be united with this one
    func getImage(withURL: String, completion: @escaping (Result<UIImage, ErrorData>) -> Void) {
        
        let initialImageURL = baseURL.appendingPathComponent("files/\(withURL)")
        var components = URLComponents(url: initialImageURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "size", value: "small")]
        let imageURL = components.url!
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    if let errorData = try? jsonDecoder.decode(ErrorData.self, from: data) {
                        completion(.failure(errorData))
                    }
                }
            }
        }
        task.resume()
    }
}
