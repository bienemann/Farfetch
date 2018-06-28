//
//  HeroDetailsViewController.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class HeroDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viwInfo: UIView!
    @IBOutlet weak var viwLoadingView: LoadingIndicatorView!
    
    var hero: MarvelCharacter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let hero = hero {
            lblName.text = hero.name
            imgThumbnail.load(hero.thumbnail?.url() ?? "")
        }
        
        drawImageFrame()
        viwLoadingView.play()
    }
    
    func drawImageFrame() {
        self.imgThumbnail.layer.borderColor = UIColor.black.cgColor
        self.imgThumbnail.layer.borderWidth = 2.0
        self.viwInfo.layer.borderColor = UIColor.black.cgColor
        self.viwInfo.layer.borderWidth = 2.0
    }
    
}
