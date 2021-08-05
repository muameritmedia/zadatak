//
//  Webservice.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import Foundation
enum NetworkError: String, Error, Equatable {
    case decodingError = "decodingError"
    case domainError = "domainError"
    case urlError = "urlError"
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class Webservice {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>)->Void) {
        print(resource.url)
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        if token != nil {
            request.setValue("Bearer "+token!, forHTTPHeaderField: "Authorization")
        }
        
        
        urlSession.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
            
            
        }.resume()
        
    }
    
    
  

}

