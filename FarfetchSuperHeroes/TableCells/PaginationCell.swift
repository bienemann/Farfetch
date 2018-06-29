//
//  PaginationCell.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 29/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class PaginationCell: UITableViewCell {
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var viewComicFrame: UIView!
    @IBOutlet weak var loading: LoadingIndicatorView!
    
    var isLoading = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewComicFrame.layer.borderColor = UIColor.black.cgColor
        viewComicFrame.layer.borderWidth = 2.0
    }
    
    func startLoading() {
        
        if isLoading { return }
        isLoading = true
        
        loading.play()
        loading.isHidden = false
        lblInfo.text = "SUMMONING"
        
    }
    
    func stopLoading() {
        
        if !isLoading { return }
        isLoading = false
        
        loading.stop()
        loading.isHidden = true
        lblInfo.text = "GIVE ME MORE CHARACTERS"
        
    }
    
}
