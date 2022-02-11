//
//  MarkerAPIController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.12.2021.
//

import Foundation

class MarkerAPIController {
    
    static let shared = MarkerAPIController()
    
    let baseURL = networkURL
    
    //Func to retrieve objects on map to attach publication (to Orgs/Events)
    func getObjectsOrgsEvents(with centerCoordinates: String, precision: Int, token: String, completion: @escaping (Result<Points, ErrorData>) -> Void) {
        let url = baseURL.appendingPathComponent("publications/near")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "pre", value: String(precision))]
        let pointsUrl = components.url!
        
        var request = URLRequest(url: pointsUrl)
        let headers = ["authorization": "Bearer \(token)"]
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let session = URLSession.init(configuration: config)
        
        let data: [String: String] = ["geoposition": centerCoordinates]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let points = try? jsonDecoder.decode(Points.self, from: data) {
                    completion(.success(points))
                } else {
                    if let errorData = try? jsonDecoder.decode(ErrorData.self, from: data) {
                        completion(.failure(errorData))
                    }
                }
            }
        }
        task.resume()   
    }
    
    //Func to fetch objects on map to cluster them
    func getMarkers(with centerCoordinates: String, precision: Int, completion: @escaping (Result<MarkerPoints, ErrorData>) -> Void) {
        let url = baseURL.appendingPathComponent("publications/map/points")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "pre", value: String(precision))]
        let pointsUrl = components.url!
        
        var request = URLRequest(url: pointsUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let data: [String: String] = ["geoposition": centerCoordinates]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let points = try? jsonDecoder.decode(MarkerPoints.self, from: data) {
                    completion(.success(points))
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
