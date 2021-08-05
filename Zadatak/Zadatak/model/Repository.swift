//
//  Repository.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import Foundation

class Repository: Codable {
    
    let id: Int
    let full_name: String?
    let description: String?
    let forks: Int?
    let open_issues: Int?
    let watchers: Int?
    let owner: Owner?
    let html_url: String?
}
