//
//  FavoriteObject.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 01/07/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class Favorite: NSObject, NSCoding {
    
    var id: Int?
    var name: String? = nil
    var picture: UIImage? = nil
    
    var comics: [MarvelComic]? = nil
    var events: [MarvelEvent]? = nil
    var series: [MarvelSerie]? = nil
    var stories: [MarvelStory]? = nil
    
    init(_ id: Int) {
        self.id = id
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(picture, forKey: "picture")
        
        aCoder.encode(comics, forKey: "comics")
        aCoder.encode(events, forKey: "events")
        aCoder.encode(series, forKey: "series")
        aCoder.encode(stories, forKey: "stories")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        picture = aDecoder.decodeObject(forKey: "picture") as? UIImage
        comics = aDecoder.decodeObject(forKey: "comics") as?  [MarvelComic]
        events = aDecoder.decodeObject(forKey: "events") as?  [MarvelEvent]
        series = aDecoder.decodeObject(forKey: "series") as?  [MarvelSerie]
        stories = aDecoder.decodeObject(forKey: "stories") as?  [MarvelStory]
        
    }

}

class FavoritesManager {
    
    static let shared = FavoritesManager()
    
    var filename: String = "favorites"
    var bundle: Bundle = Bundle.main
    var filePath: String {
        guard
            let path = bundle.path(forResource: filename, ofType: ".plist")
            else {
                // TODO: Handle Error
                return ""
        }
        
        return path
    }
    
    var all: [Favorite] {
        
        guard let favoritesObject = openFavorites() else {
            return [Favorite]()
        }
        
        return Array(favoritesObject.keys)
            .sorted { $0 < $1 }
            .compactMap { favoritesObject[$0] }
    }
    
    func openFavorites() -> [Int: Favorite]? {
        
        guard
            let favorites = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)// as? [Int: Favorite]
        else {
            // TODO: Handle Error
            return nil
        }
        
        return favorites as? [Int: Favorite]
        
    }
    
    func saveFavorite(_ object: Favorite) {
        
        var favorites = openFavorites()
        if favorites == nil {
            favorites = [Int: Favorite]()
        }
        
        favorites![object.id!] = object
        NSKeyedArchiver.archiveRootObject(favorites!, toFile: filePath)
    
    }
    
    func removeFavorite(byID id: Int) {
        var favorites = openFavorites()
        favorites?.removeValue(forKey: id)
        
        if favorites == nil {
            favorites = [Int: Favorite]()
        }
        
        NSKeyedArchiver.archiveRootObject(favorites!, toFile: FavoritesManager.shared.filePath)
    }
    
    class func removeAll() {
        let favorites = [Int: Favorite]()
        NSKeyedArchiver.archiveRootObject(favorites, toFile: FavoritesManager.shared.filePath)
    }
    
}
