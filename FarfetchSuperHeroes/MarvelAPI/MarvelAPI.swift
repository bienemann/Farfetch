//
//  MarvelAPI.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

protocol MarvelAPIProtocol {
    func get<T: Decodable>(_ endpoint: String, handler: @escaping (T?, Error?) -> Void)
    static var shared: MarvelAPIProtocol { get }
}

open class MarvelAPI: MarvelAPIProtocol {
    
    static let baseURL = "https://gateway.marvel.com"
    class var shared: MarvelAPIProtocol {
        return MarvelAPI()
    }
    
    func params() -> [String: Any?] {
        let timestamp = Int(Date().timeIntervalSince1970)
        return ["apikey": FSHConstants.marvelPubKey,
                "ts": "\(timestamp)",
                "hash": MD5.hash("\(timestamp)" + FSHConstants.marvelPvtKey + FSHConstants.marvelPubKey)]
    }
    
    func headers() -> [String: String] {
        return ["Accept": "*/*"]
    }
    
    func get<T: Decodable>(_ endpoint: String, handler: @escaping (T?, Error?) -> Void) {
        
        let url = MarvelAPI.baseURL + endpoint
        
        FSHJSONRequest<T>(url: url,
                          method: .get,
                          params: params(),
                          headers: headers())
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

extension MarvelAPIProtocol {
    
    static func getCharacters(handler: @escaping ([MarvelCharacter]?, Error?) -> Void) -> Void{
        Self.shared.get("/v1/public/characters") { (response: MarvelObject<MarvelCharacter>?, error: Error?) in
            
            guard let responseObject = response?.data?.results else {
                handler(nil, error)
                return
            }
            
            handler(responseObject, error)
            
        }
    }
    
    static func getComics(for characterId: Int, handler: @escaping ([MarvelComic]?, Error?) -> Void) -> Void {
        let endpoint = "/v1/public/characters/\(characterId)/comics"
        Self.shared.get(endpoint) { (response: MarvelObject<MarvelComic>?, error) in
            
            guard let responseObject = response?.data?.results else {
                handler(nil, error)
                return
            }
            
            handler(responseObject, error)
            
        }
    }
    
}
