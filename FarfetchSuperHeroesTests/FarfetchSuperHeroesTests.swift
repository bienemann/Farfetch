//
//  FarfetchSuperHeroesTests.swift
//  FarfetchSuperHeroesTests
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
@testable import FarfetchSuperHeroes

class InternalTestObject: Codable {
    let boolean: Bool
}

class TestObject: Codable {
    let object: InternalTestObject
    let stringValue: String
    let intValue: Int
    let doubleValue: Double
}

class FarfetchSuperHeroesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        FSHStub.shared.removeAllStubs()
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCharacters() {
        
        FSHStub.shared.stub("/v1/public/characters",
                            response: "characterMock01",
                            statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI.getCharacters { (characters, error) in
            expectation.fulfill()
            XCTAssert(characters?.first?.name == "TESTMAN")
        }
        
        self.wait(for: [expectation], timeout: 0.5)

    }
    
    func testJSON() {
        
        let jsonAddress = "https://gist.githubusercontent.com/bienemann/fb71376806de057cfb84a2e47c189728/raw/7e2e24ac6b325bc07f8158f57f84c60bb828010b/farfetchTestJSON"
        let expectation = self.expectation(description: "testing dispatcher against json in gist")
        
        FSHJSONRequest<TestObject>(url: jsonAddress, method: .get).jsonResponse { response in
            
            expectation.fulfill()
            
            switch response.result {
            case .success:
                XCTAssertNotNil(response.json)
                XCTAssert(response.json is TestObject)
                let json = response.json as! TestObject
                print(json.intValue)
                break
            case .failure:
                XCTFail()
                return
            }
        }
        
        self.wait(for: [expectation], timeout: 5.0)
        
    }
        
}
