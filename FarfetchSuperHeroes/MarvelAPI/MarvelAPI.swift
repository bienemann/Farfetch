//
//  MarvelAPI.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

protocol MarvelAPIProtocol {
    func get<T: Decodable>(_ endpoint: String,
                           params: [String: LosslessStringConvertible?],
                           headers: [String: String],
                           handler: @escaping (T?, Error?) -> Void)
    static var shared: MarvelAPIProtocol { get }
}

extension MarvelAPIProtocol {
    func get<T: Decodable>(_ endpoint: String, handler: @escaping (T?, Error?) -> Void) {
        get(endpoint, params: MarvelAPI.params(), headers: MarvelAPI.headers(), handler: handler)
    }
}

open class MarvelAPI: MarvelAPIProtocol {
    
    static let baseURL = "https://gateway.marvel.com"
    class var shared: MarvelAPIProtocol {
        return MarvelAPI()
    }
    
    class func params() -> [String: LosslessStringConvertible?] {
        let timestamp = Int(Date().timeIntervalSince1970)
        return ["apikey": FSHConstants.marvelPubKey,
                "ts": "\(timestamp)",
                "hash": MD5.hash("\(timestamp)" + FSHConstants.marvelPvtKey + FSHConstants.marvelPubKey)]
    }
    
    class func headers() -> [String: String] {
        return ["Accept": "*/*"]
    }
    
    func get<T: Decodable>(_ endpoint: String,
                           params: [String: LosslessStringConvertible?] = params(),
                           headers: [String: String] = headers(),
                           handler: @escaping (T?, Error?) -> Void) {
        
        let url = MarvelAPI.baseURL + endpoint
        
        FSHJSONRequest<T>(url: url,
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

extension MarvelAPIProtocol {
    
    static func getCharacters(_ page: Int = 0,
                              handler: @escaping ([MarvelCharacter]?, Int?, Error?) -> Void) -> Void {
        
        var params = MarvelAPI.params()
        params["limit"] = 20
        params["offset"] = 20*page
        
        Self.shared.get("/v1/public/characters", params: params, headers: MarvelAPI.headers()) {
        (response: MarvelObject<MarvelCharacter>?, error: Error?) in
            guard let responseObject = response?.data?.results else {
                handler(nil, nil, error)
                return
            }
            
            handler(responseObject, response?.data?.total ?? nil, error)
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
    
    static func getSeries(for characterId: Int, handler: @escaping ([MarvelSerie]?, Error?) -> Void) -> Void {
        let endpoint = "/v1/public/characters/\(characterId)/series"
        Self.shared.get(endpoint) { (response: MarvelObject<MarvelSerie>?, error) in
            
            guard let responseObject = response?.data?.results else {
                handler(nil, error)
                return
            }
            
            handler(responseObject, error)
            
        }
    }
    
    static func getEvents(for characterId: Int, handler: @escaping ([MarvelEvent]?, Error?) -> Void) -> Void {
        let endpoint = "/v1/public/characters/\(characterId)/events"
        Self.shared.get(endpoint) { (response: MarvelObject<MarvelEvent>?, error) in
            
            guard let responseObject = response?.data?.results else {
                handler(nil, error)
                return
            }
            
            handler(responseObject, error)
            
        }
    }
    
    static func getStories(for characterId: Int, handler: @escaping ([MarvelStory]?, Error?) -> Void) -> Void {
        let endpoint = "/v1/public/characters/\(characterId)/stories"
        Self.shared.get(endpoint) { (response: MarvelObject<MarvelStory>?, error) in
            
            guard let responseObject = response?.data?.results else {
                handler(nil, error)
                return
            }
            
            handler(responseObject, error)
            
        }
    }
    
}
