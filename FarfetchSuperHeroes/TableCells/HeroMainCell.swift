//
//  HeroMainCell.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class HeroMainCell: UITableViewCell {
    
    @IBOutlet weak var imgThumb: SelfDownloadingImageView!
    @IBOutlet weak var lblName: ComicLabel!
    @IBOutlet weak var viewComicFrame: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var viewFavContainter: FavContainer!
    
    var favorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgThumb.layer.borderColor = UIColor.black.cgColor
        imgThumb.layer.borderWidth = 2.0
        
        roundView.layer.cornerRadius = roundView.frame.height/2.0
        roundView.layer.borderColor = UIColor.black.cgColor
        roundView.layer.borderWidth = 2.0
        
    }
}

extension HeroMainCell: FavContainerProtocol {
    
    func isFavorite() -> Bool {
        return favorite
    }
    
    func didTouchFav(container: FavContainer) {
        favorite = !favorite
    }
    
}
