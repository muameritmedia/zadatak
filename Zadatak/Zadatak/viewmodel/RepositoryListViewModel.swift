//
//  RepositoryListViewModel.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import Foundation

enum ResponseStatus: String {
    case ok = "ok"
    case error = "error"
}

class RepositoryListViewModel {
    
    var repositoryList: [RepositoryViewModel]
    var urlSession: URLSession
    var page = 1
    var pagingEnabled = true
    var sort = "stars"
    var searchString = ""
    
    init(urlSession: URLSession = .shared) {
        self.repositoryList = [RepositoryViewModel]()
        self.urlSession = urlSession
    }
    
    func numberOfRowsInSection() -> Int {
        return repositoryList.count
    }
    
    func itemAtIndex(_ index: Int) -> RepositoryViewModel {
        return repositoryList[index]
    }
    
    func updateList(completition: @escaping (ResponseStatus) -> Void) {
        
        
        RepositoryListWebservice(urlSession: urlSession).fetchRepositorys(page: page) {[weak self] (response, error) in
            
            
            if let _ = error {
                completition(ResponseStatus.error)
                return
            }
            
            guard let list = response else {
                completition(ResponseStatus.error)
                return
            }
            
            
            self?.pagingEnabled = !(list.count < 30)
            
            if self?.page == 1 {
                self?.repositoryList = list.map(RepositoryViewModel.init)
            } else {
                self?.repositoryList.append(contentsOf: list.map(RepositoryViewModel.init))
            }
            completition(ResponseStatus.ok)
            
            
            
        }
        
        
    }
    
    func filterRepositoryList(completition: @escaping (ResponseStatus) -> Void) {
        
        
        FilteredRepositoryListWebservice(urlSession: urlSession).fetchFilteredRepositorys(page: page, search: searchString, sort: sort) {[weak self] (response, error) in
            
            
            if let _ = error {
                completition(ResponseStatus.error)
                return
            }
            
            guard let response = response else {
                completition(ResponseStatus.error)
                return
            }
            
            self?.pagingEnabled = !(response.items.count < 30)
            
            if self?.page == 1 {
                self?.repositoryList = response.items.map(RepositoryViewModel.init)
            } else {
                self?.repositoryList.append(contentsOf: response.items.map(RepositoryViewModel.init))
            }
            
            
            completition(ResponseStatus.ok)
            
            
            
        }
        
        
        
    
    }
    
    
}


struct RepositoryViewModel {
    let repository: Repository
}

extension RepositoryViewModel {
    
    var id: Int? {
        return self.repository.id
    }
    
    var full_name: String? {
        return self.repository.full_name
    }
    
    var description: String? {
        return self.repository.description
    }
    
    var forks: Int? {
        return self.repository.forks
    }
    
    var open_issues: Int? {
        return self.repository.open_issues
    }
    
    var watchers: Int? {
        return self.repository.watchers
    }
    var owner: Owner? {
        return self.repository.owner
    }
    
    var html_url: String? {
        return self.repository.html_url
    }
}
