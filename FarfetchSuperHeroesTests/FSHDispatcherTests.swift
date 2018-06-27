//
//  FSHDispatcherTests.swift
//  FarfetchSuperHeroesTests
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
@testable import FarfetchSuperHeroes

class FSHDispatcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDispatcherSuccess() {
        
        let expectation = self.expectation(description: "testing dispatcher against google")
        
        let request = FSHRequest(url: "http://www.google.com", method: .get)
        FSHNetworkDispatcher().dispatch(request, success: { (data) in
            expectation.fulfill()
        }) { (error) in
            expectation.fulfill()
            XCTFail()
        }
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    func testDispatcherInvalidURL() {
        
        let expectation = self.expectation(description: "testing dispatcher against google")
        
        let request = FSHRequest(url: "", method: .get)
        FSHNetworkDispatcher().dispatch(request, success: { (data) in
            expectation.fulfill()
            XCTFail()
        }) { (error) in
            XCTAssert(error is FSHNetworkError)
            XCTAssert((error as! FSHNetworkError) == FSHNetworkError.invalidURL)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5.0)
    }
}
