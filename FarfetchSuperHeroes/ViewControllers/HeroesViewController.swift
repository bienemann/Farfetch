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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FSHLoading.shared.show(true)
        MarvelAPI.getCharacters { (characters, error) in
            FSHLoading.shared.dismiss(true)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class HeroesListDataSource: NSObject, UITableViewDataSource {
    
    var heroes = [Character]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
