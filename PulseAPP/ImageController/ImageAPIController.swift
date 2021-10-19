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
        print(avatarPhotoURL)
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
}
