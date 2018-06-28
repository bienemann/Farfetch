//
//  MarvelComic.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 28/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct MarvelComic: Summarizable {
    
    func name() -> String {
        return self.title ?? "[ missing name ]"
    }
    
    func summary() -> String {
        return self.description ?? "[ missing description ]"
    }
    
    let id: Int?
    let digitalId: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription: String?
    let description: String?
    let modified: String?
    let isbn: String?
    let upc: String?
    let diamondCode: String?
    let ean: String?
    let issn: String?
    let format: String?
    let pageCount: Int?
    let textObjects: [MarvelTextObject]?
    let resourceURI: String?
    let urls: [MarvelTypedUrl]?
    let series: MarvelSeriesSummary?
    //    let variants: AnyObject?
    //    let collections: AnyObject?
    //    let collectedIssues: AnyObject?
    let dates: [MarvelEventDate]?
    let prices: [MarvelPrice]?
    let thumbnail: MarvelThumbnail?
    let images: [MarvelThumbnail]?
    let creators: MarvelGenericList<MarvelCreatorSummary>?
    let characters: MarvelGenericList<MarvelCharacterSummary>?
    let stories: MarvelGenericList<MarvelStorySummary>?
    let events: MarvelGenericList<MarvelEventSummary>?
    
}
