//
//  FilteredRepositoryResponse.swift
//  Zadatak
//
//  Created by Muamer Beginovic on 5. 8. 2021..
//

import Foundation

struct FilteredRepositoryResponse: Codable {
    
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
    
}
