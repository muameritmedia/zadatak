//
//  RepositoryListViewModelTests.swift
//  ZadatakTests
//
//  Created by Muamer Beginovic on 5. 8. 2021..
//

import XCTest
@testable import Zadatak

class RepositoryListViewModelTests: XCTestCase {

    
    
    var sut: RepositoryListViewModel!
    
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        sut = RepositoryListViewModel(urlSession: urlSession)
        
    }
    
    
    override func tearDown() {
        sut = nil
        MockUrlProtocol.stubResponseData = nil
    }
    
    
    func testFetchRepositories_WhenGivingOk() {
        
        
        let response = "[{\"id\": 1}]"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.updateList() { response in
            
            XCTAssertEqual(response, ResponseStatus.ok, "Response contains expected STATUS")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testFetchRepositories_WhenErrorTookPlace() {
        
        
        let response = "{\"id\":0}"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.updateList() { response in
            
            XCTAssertEqual(response, ResponseStatus.error, "Response contains unexpected STATUS")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    
    func testFetchFilteredRepositories_WhenGivingOk() {

        let response = "{\"total_count\": 15374324,\"incomplete_results\": true,\"items\": []}"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.filterRepositoryList() { (response) in
            
            
            XCTAssertEqual(response, ResponseStatus.ok, "Response contains expected STATUS")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testFetchFilteredRepositories_WhenErrorTookPlace() {
        
        
        let response = "{\"id\":0}"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.filterRepositoryList() { (response) in

            XCTAssertEqual(response, ResponseStatus.error, "Response contains unexpected STATUS")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    

}
