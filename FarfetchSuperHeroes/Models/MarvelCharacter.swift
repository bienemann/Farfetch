//
//  MarvelCharacter.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct MarvelCharacter: Decodable {
    
    let id: Int?
    let name: String?
    let description: String?
    let modified: Date?
    let resourceURI: String? //"http://gateway.marvel.com/v1/public/characters/1010870",
    
    let thumbnail: MarvelThumbnail?
    let comics: MarvelGenericList<MarvelComicSummary>?
    let series: MarvelGenericList<MarvelSeriesSummary>?
    let stories: MarvelGenericList<MarvelStorySummary>?
    let events: MarvelGenericList<MarvelEventSummary>?
    let urls: [MarvelTypedUrl]?
    
}
