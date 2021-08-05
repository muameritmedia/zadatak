//
//  FilteredRepositoryListWebservice.swift
//  ZadatakTests
//
//  Created by Muamer Beginovic on 5. 8. 2021..
//

import XCTest
@testable import Zadatak

class FilteredRepositoryListWebserviceTests: XCTestCase {

   
    var sut: FilteredRepositoryListWebservice!
    
    override func setUp() {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        sut = FilteredRepositoryListWebservice(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        MockUrlProtocol.stubResponseData = nil
    }
    
    
    
    func testFetchRepositories_WhenGivingSuccessFullResponse_ReturnSuccess() {

        let response = "{\"total_count\": 15374324,\"incomplete_results\": true,\"items\": []}"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.fetchFilteredRepositorys(page: 1, search: "square", sort: "forks") { (response, error) in
            
            XCTAssertNotNil(response, "Response model contains expected JSON")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testFetchRepositories_WhenGivingSuccessFullResponse_ReturnDecodingError() {

        let response = "{\"total_count\": 15374324,\"incomplete_results\": true,\"items\": []"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.fetchFilteredRepositorys(page: 1, search: "square", sort: "forks") { (response, error) in
            
            
            XCTAssertEqual(error?.rawValue, NetworkError.decodingError.rawValue)
            XCTAssertNil(response, "Response model contains unexpected JSON")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    
    
    

}
