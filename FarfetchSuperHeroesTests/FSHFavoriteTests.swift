//
//  FSHFavoriteTests.swift
//  FarfetchSuperHeroesTests
//
//  Created by Allan Martins on 01/07/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
@testable import FarfetchSuperHeroes

class FSHFavoriteTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        FavoritesManager.shared.bundle = Bundle(for: type(of: self))
        FavoritesManager.shared.filename = "testFavorites"
        FavoritesManager.removeAll()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSavingFavorites() {
        
        let fav01 = Favorite(id: 111, name: "testman", picture: "picture url")
        FavoritesManager.shared.saveFavorite(fav01)
        
        let fav02 = Favorite(id: 112, name: "testman02", picture: "picture url")
        FavoritesManager.shared.saveFavorite(fav02)
        
        guard let favorites = FavoritesManager.shared.openFavorites() else {
            XCTFail()
            return
        }
        
        XCTAssert(favorites.count == 2)
        XCTAssert(favorites[112]?.name == "testman02")

        
    }
    
    func testList() {
        
        let fav01 = Favorite(id: 111, name: "testman", picture: "picture url")
        FavoritesManager.shared.saveFavorite(fav01)
        
        let fav02 = Favorite(id: 112, name: "testman02", picture: "picture url")
        FavoritesManager.shared.saveFavorite(fav02)
        
        let names = FavoritesManager.shared.all.reduce("") { (result, favorite) -> String in
            return result + favorite.name!
        }
        
        XCTAssert(names == "testmantestman02")
    }
    
    func testRemove() {
        
        let fav01 = Favorite(id: 111, name: "testman", picture: "picture url")
        FavoritesManager.shared.saveFavorite(fav01)
        
        let fav02 = Favorite(id: 112, name: "testman02", picture: "picture url")
        FavoritesManager.shared.saveFavorite(fav02)
        
        XCTAssert(FavoritesManager.shared.all.count == 2)
        
        FavoritesManager.shared.removeFavorite(byID: 111)
        
        XCTAssert(FavoritesManager.shared.all.count == 1)
        
        FavoritesManager.shared.removeFavorite(byID: 111)
        
        XCTAssert(FavoritesManager.shared.all.count == 1)
        
        FavoritesManager.shared.removeFavorite(byID: 112)
        
        XCTAssert(FavoritesManager.shared.all.count == 0)
        
    }
    
}
