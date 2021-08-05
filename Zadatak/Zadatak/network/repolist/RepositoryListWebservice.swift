//
//  RepositoryListWebservice.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import Foundation


class RepositoryListWebservice {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    
    func fetchRepositorys(page: Int, completition: @escaping ([Repository]?, NetworkError?) -> Void) {
        
        
        let urlString = String(format: ApiService.REPOSITORY_LIST, page)
        
        
        
        guard let url = URL(string: urlString) else {
            completition(nil, NetworkError.domainError)
            return
            
        }
        
        
        let resource = Resource<[Repository]>(url: url)
        
        Webservice(urlSession: urlSession).load(resource: resource) { result in
            
            switch result {
            
            case .success(let response):
                completition(response, nil)
            
            case .failure(let error):
                completition(nil, error)
            
            }
            
            
            
        }
        
        
        
    }
    
}
