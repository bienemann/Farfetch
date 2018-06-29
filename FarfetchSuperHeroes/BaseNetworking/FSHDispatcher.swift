//
//  FSHDispatcher.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

public enum FSHNetworkError: Swift.Error {
    case invalidURL
    case noData
}

struct NetworkConstants {
    public static let networkQueueName = "com.farfetch.networking"
    public static let netQueue = DispatchQueue(label: networkQueueName,
                                    qos: .userInitiated)
}

class FSHNetworkDispatcher<T: FSHRequestProtocol> {
    
    @discardableResult func dispatch(_ request: T,
                  success: @escaping (Data) -> Void,
                  failure: @escaping (Error) -> Void) -> URLSessionDataTask? {
        
        var urlRequest: URLRequest! = nil
        
        do {
            urlRequest = try self.buildRequest(from: request)
        } catch let error {
            failure(error)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(FSHNetworkError.noData)
                }
                return
            }
            
            DispatchQueue.main.async {
                success(data)
            }
        }
        
        NetworkConstants.netQueue.async {
            task.resume()
        }
        
        return task
        
    }
    
    func buildRequest(from request: T) throws -> URLRequest {
        
        guard
            !request.url.isEmpty,
            var urlComponents = URLComponents(string: request.url)
            else {
                throw FSHNetworkError.invalidURL
        }
        
        var bodyData: Data? = nil
        if let params = request.params {
            
            if request.method == .get {
                
                var components = URLComponents()
                components.queryItems = params.compactMap({ (key, value) -> URLQueryItem? in
                    if let value = value?.description {
                        return URLQueryItem(name: key, value: value)
                    }
                    return nil
                })
                urlComponents.query = components.query
                
            } else {
                
                do {
                    bodyData = try JSONSerialization.data(withJSONObject: params, options: [])
                } catch let error {
                    throw error
                }
                
            }
        }
        
        guard let finalURL = urlComponents.url else {
            throw FSHNetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: finalURL, cachePolicy: .returnCacheDataElseLoad)
        urlRequest.httpMethod = request.method.rawValue.uppercased()
        urlRequest.httpBody = bodyData
        
        return urlRequest
        
    }
    
}
