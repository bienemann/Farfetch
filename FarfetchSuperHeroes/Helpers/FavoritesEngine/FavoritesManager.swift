//
//  FavoritesManager.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 02/07/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

class FavoritesManager {
    
    static let shared = FavoritesManager()
    
    var filename: String = "favorites"
    var bundle: Bundle = Bundle.main
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent(filename+".plist").path)
    }
    
    var all: [Favorite] {
        
        guard let favoritesObject = openFavorites() else {
            return [Favorite]()
        }
        
        return Array(favoritesObject.keys)
            .sorted { $0 < $1 }
            .compactMap { favoritesObject[$0] }
    }
    
    var index: [Int] {
        guard let favoritesObject = openFavorites() else {
            return [Int]()
        }
        return Array(favoritesObject.keys)
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
        if NSKeyedArchiver.archiveRootObject(favorites!, toFile: filePath) {
            print("saved successfully")
        } else {
            print("failed saving")
        }
        
    }
    
    func removeFavorite(byID id: Int) {
        var favorites = openFavorites()
        favorites?.removeValue(forKey: id)
        
        if favorites == nil {
            favorites = [Int: Favorite]()
        }
        
        if NSKeyedArchiver.archiveRootObject(favorites!, toFile: filePath) {
            print("saved successfully")
        } else {
            print("failed saving")
        }
    }
    
    class func removeAll() {
        let favorites = [Int: Favorite]()
        if NSKeyedArchiver.archiveRootObject(favorites, toFile: FavoritesManager.shared.filePath) {
            print("saved successfully")
        } else {
            print("failed saving")
        }
    }
    
}
