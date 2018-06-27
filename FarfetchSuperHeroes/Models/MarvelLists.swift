//
//  MarvelLists.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct MarvelGenericList<T: Decodable>: Decodable {
    let available: Int
    let collectionURI: String
    let returned: Int
    let items: [T]
}

struct MarvelComicSummary: Decodable {
    let resourceURI: String
    let name: String
}

struct MarvelStorySummary: Decodable {
    let resourceURI: String
    let name: String
    let type: String
}

struct MarvelSeriesSummary: Decodable {
    let resourceURI: String
    let name: String
}

struct MarvelEventSummary: Decodable {
    let resourceURI: String
    let name: String
}
