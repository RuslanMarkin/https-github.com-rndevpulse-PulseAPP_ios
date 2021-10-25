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
    
    //Retrieves a pile of user's publications (20) with multiplier (with coef)
    //User's id is passed in body of POST request
    func getUserPublications(withToken: String, withCoef: Int){
        //completion: @escaping (Result<[FetchedPublication], Error>) -> Void
        let subscriptionsURL = baseURL.appendingPathComponent("subscriptions/publications/\(withCoef)")
        
        var request = URLRequest(url: subscriptionsURL)
        request.httpMethod = "GET"
        let headers = ["authorization": "Bearer \(withToken)"]
        request.allHTTPHeaderFields = headers
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
            let jsonDecoder = JSONDecoder()
            if let data = data, let publicationsData = try? jsonDecoder.decode(UserPublications.self, from: data) {
            //    completion(.success(publicationsData))
                print(publicationsData.publications)
            } else {
                print("error")
            //    completion(.failure(ErrorHandler.couldntFetchPublications(500, "No publications found")))
            }
        }
        task.resume()
    }
     
    func getMyPublications(withUserId: String, withToken: String, withCoef: Int) {
        let publicationsURL = baseURL.appendingPathComponent("publications/posts/\(withCoef)")
        
        var request = URLRequest(url: publicationsURL)
        let headers = ["authorization": "Bearer \(withToken)"]
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession.init(configuration: config)
        
        let data: [String: String] = ["id": withUserId]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
            let jsonDecoder = JSONDecoder()
            if let data = data, let myPublications = try? jsonDecoder.decode(UserPublications.self, from: data) {
                print(myPublications.publications)
            } else {
                print("error")
                //completion(.failure(ErrorHandler.imageNotFound(400)))
            }
        }
        task.resume()
    }
}
