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
    
    func dispatch(_ request: T, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        
        NetworkConstants.netQueue.async {
            guard let url = URL(string: request.url) else {
                DispatchQueue.main.async {
                    failure(FSHNetworkError.invalidURL)
                }
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue.uppercased()
            
            do {
                if let params = request.params {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
                }
            } catch let error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
                }.resume()
        }
        
    }
}
