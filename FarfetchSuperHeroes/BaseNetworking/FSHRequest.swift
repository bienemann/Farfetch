//
//  FSHRequest.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
}

protocol FSHRequestJSONProtocol: FSHRequestProtocol {
    associatedtype JSONResult: Decodable
}

protocol FSHRequestProtocol {
    
    var url: String { get set }
    var method: HTTPMethod { get set }
    var params: [String: LosslessStringConvertible?]? { get set }
    var headers: [String: String]? { get set }
    
    init(url: String, method: HTTPMethod, params: [String: LosslessStringConvertible?]?, headers: [String: String]?)
    init(url: String, method: HTTPMethod)
}

extension FSHRequestProtocol {
    
    func dataResponse(_ handler: @escaping (FSHDataResponse<Any>) -> Void) -> URLSessionDataTask? {
        
        let successBlock: (Data) -> Void = { data in
            let response: FSHDataResponse<Any> =
                FSHDataResponse(result: .success(data),
                                data: data, error: nil, json: nil)
            handler(response)
        }
        
        return FSHNetworkDispatcher<Self>().dispatch(self, success: successBlock) { (error) in
            let response: FSHDataResponse<Any> =
                FSHDataResponse(result: .failure(error),
                                data: nil, error: error, json: nil)
            handler(response)
        }
    }
}

extension FSHRequestJSONProtocol {
    
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
        
        FSHNetworkDispatcher<Self>().dispatch(self, success: successBlock) { (error) in
            let response: FSHDataResponse<Any> =
                FSHDataResponse(result: .failure(error),
                                data: nil, error: error, json: nil)
            handler(response)
        }
    }
}

struct FSHDataResponse<T> {
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    var result: FSHDataResponse.Result<T>
    var data: Data?
    var error: Error?
    var json: Decodable?
}

class FSHRequest: FSHRequestProtocol {
    
    var url: String
    var method: HTTPMethod
    var params: [String : LosslessStringConvertible?]?
    var headers: [String : String]?
    
    required init(url: String,
                  method: HTTPMethod,
                  params: [String: LosslessStringConvertible?]? = nil,
                  headers: [String: String]? = nil) {
        
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
        
    }
    
    required convenience init(url: String, method: HTTPMethod) {
        self.init(url: url, method: method, params:nil, headers:nil)
    }
    
}

class FSHJSONRequest<T>: FSHRequest, FSHRequestJSONProtocol where T: Decodable {
    typealias JSONResult = T
}
