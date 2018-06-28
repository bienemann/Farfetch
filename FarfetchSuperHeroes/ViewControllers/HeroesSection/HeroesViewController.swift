//
//  FirstViewController.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import UIKit

class HeroesViewController: UIViewController {
    
    @IBOutlet weak var heroesList: UITableView!
    
    var heroes = [MarvelCharacter]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heroesList.dataSource = self
        self.heroesList.delegate = self
        
        let nib = UINib(nibName: "HeroMainCell", bundle: Bundle.main)
        self.heroesList.register(nib, forCellReuseIdentifier: "hero_main_cell")
        
        FSHLoading.shared.show(true)
        MarvelAPI.getCharacters { (characters, error) in
            FSHLoading.shared.dismiss(true)
            
            guard
                let characters = characters,
                error == nil
            else {
                // TODO manage errors
                return
            }
            
            self.heroes = characters
            self.heroesList.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "hero_details",
        let hero = sender as? MarvelCharacter,
        let destination = segue.destination as? HeroDetailsViewController {
            destination.hero = hero
        }
    }
}

extension HeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "hero_details", sender: heroes[indexPath.row])
    }
}

extension HeroesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "hero_main_cell",
                                                     for: indexPath) as? HeroMainCell
        else {
            return UITableViewCell()
        }
        
        cell.imgThumb.image = UIImage(named: "downloadImagePlaceholder")
        cell.selectionStyle = .none
        
        let hero = heroes[indexPath.row]
        cell.imgThumb.load(hero.thumbnail.url())
        cell.lblName.text = hero.name
        
        return cell
        
    }
    
}
