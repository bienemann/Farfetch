//
//  FakeDispatcher.swift
//  FarfetchSuperHeroesTests
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
@testable import FarfetchSuperHeroes

class FSHStub {
    
    struct StubData {
        var file: String?
        var statusCode: Int?
    }
    
    static let shared = FSHStub()
    var stubs = [String: StubData]()
    var filters = [String: StubData]()
    
    func stub(_ url: String, response filePath: String, statusCode: Int) {
        self.stubs[url] = StubData(file: filePath, statusCode: statusCode)
    }
    
    func remove(_ url: String) {
        self.stubs.removeValue(forKey: url)
    }
    
    func removeAllStubs() {
        self.stubs.removeAll()
    }
    
    func changeResultsFrom(stubURL: String, byParameter: String, value: LosslessStringConvertible,
                           response filePath: String, statusCode: Int) {
        
        guard let _ = self.stubs[stubURL] else {
            return
        }
        
        self.filters[byParameter+value.description] = StubData(file: filePath, statusCode: statusCode)
    }
    
    func data(for url: URL) -> Data? {
        
        guard
            let stub = stubs[url.path],
            var filePath = Bundle.init(for: FSHStub.self).path(forResource: stub.file, ofType: "json")
        else {
            return nil
        }
        
        if url.query != nil {
            if let existingFilter = filters.first(where: { (filter, _) -> Bool in
                return url.query!.range(of: filter) != nil
            }) {
                if let filterPath = Bundle.init(for: FSHStub.self)
                    .path(forResource: existingFilter.value.file, ofType: "json") {
                    filePath = filterPath
                }
            }
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
    
}

class FakeDispatcher<T: FSHRequestProtocol>: FSHNetworkDispatcher<T> {

    @discardableResult override func dispatch(_ request: T,
                           success: @escaping (Data) -> Void,
                           failure: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
            
            do {
                let urlRequest = try self.buildRequest(from: request)
                
                guard let url = urlRequest.url else {
                    DispatchQueue.main.async {
                        failure(FSHNetworkError.invalidURL)
                    }
                    return nil
                }
                
                if let responseData = FSHStub.shared.data(for: url) {
                    DispatchQueue.main.async {
                        success(responseData)
                    }
                    return nil
                }
                
                DispatchQueue.main.async {
                    failure(FSHNetworkError.noData)
                }
                
                
            } catch let error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return nil
            }
        
        return nil
        
    }
    
}

protocol FakeFSHRequestJSONProtocol: FSHRequestProtocol {
    associatedtype JSONResult: Decodable
}

class FakeFSHJSONRequest<T>: FSHRequest, FakeFSHRequestJSONProtocol where T: Decodable {
    typealias JSONResult = T
}

extension FakeFSHRequestJSONProtocol {
    
    func jsonResponse(_ handler: @escaping (FSHDataResponse<Any>) -> Void) {
        
        let successBlock: (Data) -> Void = { data in
            do {
                let jsonDecoder = FSHJSONDecoder()
                let result = try jsonDecoder.decode(JSONResult.self, from: data)
                let response: FSHDataResponse<Any> =
                    FSHDataResponse(result: .success(result),
                                    data: data, error: nil, json: result)
                handler(response)
            } catch let error {
                let response: FSHDataResponse<Any> =
                    FSHDataResponse(result: .failure(error),
                                    data: nil, error: error, json: nil)
                handler(response)
            }
        }
        
        FakeDispatcher<Self>().dispatch(self, success: successBlock) { (error) in
            let response: FSHDataResponse<Any> =
                FSHDataResponse(result: .failure(error),
                                data: nil, error: error, json: nil)
            handler(response)
        }
    }
    
}

class MockMarvelAPI: MarvelAPI {

    override class var shared: MarvelAPIProtocol {
        return MockMarvelAPI()
    }
    
    override func get<T>(_ endpoint: String,
                         params: [String : LosslessStringConvertible?],
                         headers: [String : String],
                         handler: @escaping (T?, Error?) -> Void) where T : Decodable {
        
        let url = MarvelAPI.baseURL + endpoint
        
        FakeFSHJSONRequest<T>(url: url,
                              method: .get,
                              params: params,
                              headers: headers)
            .jsonResponse { response in
                
                switch response.result {
                case .success(let json):
                    
                    guard let json = json as? T else {
                        handler(nil, nil) //TODO
                        return
                    }
                    
                    handler(json, nil)
                    return
                    
                case .failure(let error):
                    handler(nil, error)
                    return
                }
        }
    }
}
