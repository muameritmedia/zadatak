//
//  RepositoryListWebserviceTest.swift
//  ZadatakTests
//
//  Created by Muamer Beginovic on 4. 8. 2021..
//

import XCTest
@testable import Zadatak

class RepositoryListWebserviceTest: XCTestCase {

    var sut: RepositoryListWebservice!
    
    override func setUp() {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        sut = RepositoryListWebservice(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        MockUrlProtocol.stubResponseData = nil
    }
    
    
    
    func testFetchRepositories_WhenGivingSuccessFullResponse_ReturnSuccess() {
        
        
        let response = "[{\"id\": 1}]"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        let expectation = self.expectation(description: "Repository Web Service Response Expectation")
        
        
        sut.fetchRepositorys(page: 1) { (response, error) in
            
            XCTAssertNotNil(response, "Response model contains expected JSON")
            
            expectation.fulfill()
        }
        
        
        self.wait(for: [expectation], timeout: 5)
        
        
    }
    
    func testFetchRepositories_WhenGivingErrorResponse_ReturnDecodingError() {
//        let response = "[{\"id\": 1}]"

        let response = "[{\"node_id\": 1}]"
        MockUrlProtocol.stubResponseData = response.data(using: .utf8)
        
        
        let expectation = self.expectation(description: "Decoding Error Expectation")
        
        sut.fetchRepositorys(page: 1) { (response, error) in
            
            
            XCTAssertEqual(error?.rawValue, NetworkError.decodingError.rawValue, "The fetch respositories method did not return expected JSON data")
            XCTAssertNil(response, "When decoding error takes place, the response model must be nil")
            
            
            expectation.fulfill()
            
        }
        
        self.wait(for: [expectation], timeout: 5)

        
    }
    
    
    
    
    
}
