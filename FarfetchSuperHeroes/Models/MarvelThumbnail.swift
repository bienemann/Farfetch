//
//  MarvelThumbnail.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct MarvelThumbnail: Decodable {
    
    let path: String
    let filetype: String
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case filetype = "extension"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        filetype = try container.decode(String.self, forKey: .filetype)
    }
    
}
