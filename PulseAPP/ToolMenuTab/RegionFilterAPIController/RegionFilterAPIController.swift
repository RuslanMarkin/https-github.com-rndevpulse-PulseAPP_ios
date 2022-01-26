//
//  RegionFilterAPIController.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 24.01.2022.
//

import Foundation

class RegionFilterAPIController {
    
    static let shared = RegionFilterAPIController()
    
    let baseURL = networkURL
    
    func fetchRegionsToFilter(searchArea: String, resultType: String, completion: @escaping (Result<[RegionData], ErrorData>) -> Void) {
        let url = baseURL.appendingPathComponent("region")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "culture", value: "ru")]
        let regionURL = components.url!
        
        var request = URLRequest(url: regionURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: String] = ["SearchArea": searchArea, "ResultType": resultType]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data {
                if let regions = try? jsonDecoder.decode([RegionData].self, from: data) {
                    completion(.success(regions))
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
