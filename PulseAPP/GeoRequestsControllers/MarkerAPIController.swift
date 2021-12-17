//
//  MarkerAPIController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.12.2021.
//

import Foundation

class MarkerAPIController {
    
    static let shared = MarkerAPIController()
    
    let baseURL = URL(string: "http://192.168.1.100:/api/v1/")!
    
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
}
