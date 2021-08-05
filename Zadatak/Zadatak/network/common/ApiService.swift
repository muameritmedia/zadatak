//
//  ApiService.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import Foundation

struct ApiService {
    
    static let BASE_URL = "https://api.github.com/"
    
    
    static let REPOSITORY_LIST = "\(BASE_URL)repositories?page=%d"
    
    static let SEARCH_REPOSITORY_LIST = "\(BASE_URL)search/repositories?page=%d&q=%@&sort=%@"
    
    
}
