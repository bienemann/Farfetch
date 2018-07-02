//
//  FavContainer.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 02/07/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol FavContainerProtocol: class {
    func isFavorite() -> Bool
    func didTouchFav(container: FavContainer)
}

class FavContainer: UIView {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var delegate: FavContainerProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgHeart.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    @IBAction func toggleFav(sender: UIButton) {
        animateToggle(toFavorite: !(delegate?.isFavorite() ?? false))
        self.delegate?.didTouchFav(container: self)
    }
    
    func setFavoriteImage(_ favorite: Bool) {
        if favorite {
            self.imgHeart.image = #imageLiteral(resourceName: "red_heart")
        } else {
            self.imgHeart.image = #imageLiteral(resourceName: "grey_heart")
        }
    }
    
    private func animateToggle(toFavorite: Bool) {
        
        let toImage = toFavorite ? #imageLiteral(resourceName: "red_heart") : #imageLiteral(resourceName: "grey_heart")
        
        UIView.animate(withDuration: 0.2, animations: {
            self.imgHeart.transform = CGAffineTransform(scaleX: 0.001,y: 1.0)
        }) { (finished) in
            self.imgHeart.image = toImage
            UIView.animate(withDuration: 0.2, animations: {
                self.imgHeart.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
            })
        }
    }
    
}
