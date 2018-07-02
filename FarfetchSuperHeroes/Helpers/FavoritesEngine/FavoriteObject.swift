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
    var picture: String? = nil
    
    init(id: Int, name: String, picture: String) {
        
        self.id = id
        self.name = name
        self.picture = picture
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(picture, forKey: "picture")
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        picture = aDecoder.decodeObject(forKey: "picture") as? String
        
    }

}
