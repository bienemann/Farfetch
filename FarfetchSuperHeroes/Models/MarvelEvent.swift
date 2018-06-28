//
//  MarvelEvent.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 28/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct MarvelEvent: Summarizable {
    
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
    let urls: [MarvelTypedUrl]?
    let modified: Date?
    let start: Date?
    let end: Date?
    let thumbnail: MarvelThumbnail?
    let comics: MarvelGenericList<MarvelComicSummary>?
    let series: MarvelGenericList<MarvelSeriesSummary>?
    let stories: MarvelGenericList<MarvelStorySummary>?
    let creators: MarvelGenericList<MarvelCreatorSummary>?
    let characters: MarvelGenericList<MarvelCharacterSummary>?
    let next: MarvelEventSummary?
    let previous: MarvelEventSummary?
    
}
