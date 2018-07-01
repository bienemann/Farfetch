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
    }
    
    override func tearDown() {
        FSHStub.shared.removeAllStubs()
        super.tearDown()
    }
    
    func testCharacters() {
        
        FSHStub.shared.stub("/v1/public/characters",
                            response: "characterMock01",
                            statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI.getCharacters { (characters, total, error) in
            expectation.fulfill()
            XCTAssert(characters?.first?.name == "TESTMAN")
        }
        
        self.wait(for: [expectation], timeout: 0.5)

    }
    
    func testPagination() {
        
        FSHStub.shared.stub("/v1/public/characters",
                            response: "characterMock02",
                            statusCode: 200)
        FSHStub.shared.changeResultsFrom(stubURL: "/v1/public/characters",
                                         byParameter: "offset", value: 20,
                                         response: "characterMock02", statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI
            .getCharacters(1, handler: { (characters, total, error) in
                expectation.fulfill()
                XCTAssert(characters?.first?.id == 1011194)
            })
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testComics() {
        FSHStub.shared.stub("/v1/public/characters/1011334/comics",
                            response: "comicsMock",
                            statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI.getComics(for: 1011334) { (comics, error) in
            expectation.fulfill()
            XCTAssert(comics!.first!.id == 22506)
        }
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testStories() {
        FSHStub.shared.stub("/v1/public/characters/1011334/stories",
                            response: "storiesMock",
                            statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI.getStories(for: 1011334) { (stories, error) in
            expectation.fulfill()
            XCTAssert(stories!.first!.id == 19947)
        }
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testEvents() {
        FSHStub.shared.stub("/v1/public/characters/1011334/events",
                            response: "eventsMock",
                            statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI.getEvents(for: 1011334) { (events, error) in
            expectation.fulfill()
            XCTAssert(events!.first!.id == 269)
        }
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testSeries() {
        FSHStub.shared.stub("/v1/public/characters/1011334/series",
                            response: "seriesMock",
                            statusCode: 200)
        
        let expectation = self.expectation(description: "")
        
        MockMarvelAPI.getSeries(for: 1011334) { (series, error) in
            expectation.fulfill()
            XCTAssert(series!.first!.id == 1945)
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
