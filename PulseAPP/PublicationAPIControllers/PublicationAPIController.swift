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
            if let data = data, let publicationsData = try? jsonDecoder.decode(UsersPublications.self, from: data) {
            //    completion(.success(publicationsData))
                print(publicationsData.items)
            } else {
                print("error")
            //    completion(.failure(ErrorHandler.couldntFetchPublications(500, "No publications found")))
            }
        }
        task.resume()
    }
    
    //Fetch user's publications with counter 'withCoef'
    func getMyPublications(withUserId: String, withToken: String, withCoef: Int, completion: @escaping (Result<[UserPublication]?, ErrorData>) -> Void) {
        let publicationsURL = baseURL.appendingPathComponent("publications/user/\(withCoef)")
        
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
            if let data = data {
                if let myPublications = try? jsonDecoder.decode([UserPublication].self, from: data) {
                    completion(.success(myPublications))
                } else {
                    if let errorData = try? jsonDecoder.decode(ErrorData.self, from: data) {
                        completion(.failure(errorData))
                    }
                }
            }
        }
        task.resume()
    }
    
    //Fetch publications filtered by categories and type
    func getPublications(ofType: String, ofCategories: [String], afterPublicationWithLastId: String, with coef: Int, completion: @escaping (Result<[UserPublication]?, ErrorData>) -> Void) {
        let url = baseURL.appendingPathComponent("publications/\(coef)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let data: [String: Any] = ["lastid": afterPublicationWithLastId, "name": ofType, "category": ofCategories]

        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let myPublications = try? jsonDecoder.decode([UserPublication].self, from: data) {
                    completion(.success(myPublications))
                } else {
                    if let errorData = try? jsonDecoder.decode(ErrorData.self, from: data) {
                        completion(.failure(errorData))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getPublicationTypes(completion: @escaping (Result<[PublicationType], Error>) -> Void) {
        let typesURL = baseURL.appendingPathComponent("publications/types")
        
        var request = URLRequest(url: typesURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let publicationTypes = try? jsonDecoder.decode([PublicationType].self, from: data) {
                completion(.success(publicationTypes))
            } else {
                completion(.failure(ErrorHandler.imageNotFound(400)))
            }
        }
        task.resume()
    }
    
    func getPublicationCategories(completion: @escaping (Result<[PublicationCategories], Error>) -> Void) {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        var request = URLRequest(url: categoriesURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let publicationCategories = try? jsonDecoder.decode([PublicationCategories].self, from: data) {
                completion(.success(publicationCategories))
            } else {
                completion(.failure(ErrorHandler.badRequest(505, "Error")))
            }
        }
        task.resume()
    }
    
    func upload(publication: PublicationServerUpload, with token: String, completion: @escaping (Result <PublicationServerResponse, ServerErrorData>) -> Void) {
        let url = baseURL.appendingPathComponent("publications/posts/create")
        
        var request = URLRequest(url: url)
        let headers = ["authorization": "Bearer \(token)"]
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession.init(configuration: config)
        
        let data: [String: Any] = ["userId": publication.userId, "description": publication.description, "geoposition": publication.geoposition, "publicationCategories": publication.publicationCategories, "publicationTypeId": publication.publicationTypeId, "files": publication.files]

        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
        if let jsonData = jsonData {
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
            print(jsonString)
        }
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let publicationResponse = try? jsonDecoder.decode(PublicationServerResponse.self, from: data) {
                    completion(.success(publicationResponse))
                } else {
                    if let errorData = try? jsonDecoder.decode(ServerErrorData.self, from: data) {
                        completion(.failure(errorData))
                    }
                }
            }
        }
        task.resume()
    }
}
