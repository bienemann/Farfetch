//
//  MarvelStory.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 28/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct MarvelStory: Summarizable {
    
    func name() -> String {
        return self.title ?? "[ missing name ]"
    }
    
    func summary() -> String {
        return self.description ?? "[ missing description ]"
    }
    
    let id: Int?
    let title: String?
    let description: String?
    let resourceURI: String?
    let type: String?
    let modified: Date?
    let thumbnail: MarvelThumbnail?
    let comics: MarvelGenericList<MarvelComicSummary>?
    let series: MarvelGenericList<MarvelSeriesSummary>?
    let events: MarvelGenericList<MarvelEventSummary>?
    let characters: MarvelGenericList<MarvelCharacterSummary>?
    let creators: MarvelGenericList<MarvelCreatorSummary>?
    let originalissue: MarvelComicSummary?
    
}
