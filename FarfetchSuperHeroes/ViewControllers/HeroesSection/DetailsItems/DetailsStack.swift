//
//  ComicsDetails.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 28/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class DetailsStack: UIStackView {
    
    @IBOutlet weak var view: UIStackView!
    @IBOutlet weak var title: UILabel!

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    private func xibSetup() {
        loadView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func loadView() {
        let nib = UINib(nibName: "DetailsStack", bundle: Bundle.main)
        nib.instantiate(withOwner: self, options: nil)
        return
    }
    
    func setup() {
        self.frame = bounds
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addDetailView(name: String, text: String) {
        
        let newDetail = DetailView(frame: CGRect.zero)
        newDetail.name.text = name
        newDetail.detailDescription.text = text
        newDetail.setup()
        
        self.view.addArrangedSubview(newDetail.view)
        self.view.invalidateIntrinsicContentSize()
        self.view.setNeedsUpdateConstraints()
        
    }
    
}

class DetailView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    private func xibSetup() {
        loadView()
    }
    
    private func loadView() {
        let nib = UINib(nibName: "DetailView", bundle: Bundle.main)
        nib.instantiate(withOwner: self, options: nil)
    }
    
    func setup() {
        self.view.invalidateIntrinsicContentSize()
        self.view.setNeedsUpdateConstraints()
    }
    
    
}
