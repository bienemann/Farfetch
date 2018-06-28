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
    @IBOutlet weak var stackInfo: UIStackView!
    @IBOutlet weak var viwLoadingView: LoadingIndicatorView!
    
    var hero: MarvelCharacter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let hero = hero {
            lblName.text = hero.name
            imgThumbnail.load(hero.thumbnail?.url() ?? "")
        }
        
        drawImageFrame()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let comicsView = DetailsStack(frame: CGRect.zero)
        comicsView.title.text = "Stack 1"
        comicsView.addDetailView(name: "teste01", text: "desc01")
        comicsView.addDetailView(name: "teste02", text: "desc02")
        comicsView.invalidateIntrinsicContentSize()
        
        let comicsView02 = DetailsStack(frame: CGRect.zero)
        comicsView02.title.text = "Stack 2"
        comicsView02.addDetailView(name: "teste03", text: "desc03")
        comicsView02.invalidateIntrinsicContentSize()
        
        stackInfo.addArrangedSubview(comicsView.view)
        stackInfo.addArrangedSubview(comicsView02.view)
        stackInfo.translatesAutoresizingMaskIntoConstraints = false
        
        stackInfo.invalidateIntrinsicContentSize()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func drawImageFrame() {
        self.imgThumbnail.layer.borderColor = UIColor.black.cgColor
        self.imgThumbnail.layer.borderWidth = 2.0
        self.viwInfo.layer.borderColor = UIColor.black.cgColor
        self.viwInfo.layer.borderWidth = 2.0
    }
    
}
