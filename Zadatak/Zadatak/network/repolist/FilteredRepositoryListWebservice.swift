//
//  FilteredRepositoryListWebservice.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 5. 8. 2021..
//

import Foundation

class FilteredRepositoryListWebservice{
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    
    
    func fetchFilteredRepositorys(page: Int, search: String, sort: String, completition: @escaping (FilteredRepositoryResponse?, NetworkError?) -> Void) {
        
        
        
        let urlString = String(format: ApiService.SEARCH_REPOSITORY_LIST, page, search, sort )
        
        
        
        guard let url = URL(string: urlString) else {
            completition(nil, NetworkError.domainError)
            return
            
        }
        
        
        let resource = Resource<FilteredRepositoryResponse>(url: url)
        
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
