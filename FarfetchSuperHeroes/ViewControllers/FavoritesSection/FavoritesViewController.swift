//
//  SecondViewController.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesList.register(UINib(nibName: "HeroMainCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: "hero_main_cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesList.reloadData()
    }

}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "hero_main_cell",
                                                     for: indexPath) as? HeroMainCell
            else {
                return UITableViewCell()
        }
        
        cell.viewFavContainter.isHidden = true
        cell.imgThumb.image = UIImage(named: "downloadImagePlaceholder")
        
        let fav = FavoritesManager.shared.all[indexPath.row]
        cell.imgThumb.load(fav.picture!)
        cell.lblName.text = fav.name!
        
        cell.selectionStyle = .none
        return cell
        
    }
    
}

