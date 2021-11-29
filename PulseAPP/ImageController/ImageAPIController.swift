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
    
//    func uploadImage(image: UIImage, completion: @escaping (Result<UploadImageResponseData, ServerErrorData>) -> Void) {
//        let uploadImageURL = baseURL.appendingPathComponent("files/images/create")
//
//        var request = URLRequest(url: uploadImageURL)
//        request.allHTTPHeaderFields = header
//        request.httpMethod = MethodHttp.post.rawValue
//
//        let boundary = generateBoundaryString()
//
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        // built data from img
//        if let imageData = image.jpegData(compressionQuality: 1) {
//                request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
//            }
//
//            let task =  URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
//                if let data = data {
//                    debugPrint("image uploaded successfully \(data)")
//                } else if let error = error {
//                    debugPrint(error.localizedDescription)
//                }
//            })
//            task.resume()
//    }
    
    func uploadImage(with token: String, pathToFile: String, fileExtension: String, image: UIImage, completion: @escaping (Result<UploadImageResponseData, ServerErrorData>) -> Void) {
        let url = baseURL.appendingPathComponent("files/images/create")

        
        var request = URLRequest(url: url)
        let headers = ["authorization": "Bearer \(token)"]
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession.init(configuration: config)
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(pathToFile)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/\(fileExtension)\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1.0)!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
           if error == nil {
               let jsonDecoder = JSONDecoder()
               if let data = data {
                   if let imageId = try? jsonDecoder.decode(UploadImageResponseData.self, from: data) {
                       completion(.success(imageId))
                   } else {
                       if let imageError = try? jsonDecoder.decode(ServerErrorData.self, from: data) {
                           completion(.failure(imageError))
                       }
                   }
               }
           }
        }).resume()
    }
}





