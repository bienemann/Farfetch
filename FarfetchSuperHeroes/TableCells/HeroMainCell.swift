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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewComicFrame.layer.borderColor = UIColor.black.cgColor
        viewComicFrame.layer.borderWidth = 2.0
    }
    
}
