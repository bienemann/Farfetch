//
//  FirstViewController.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 26/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import UIKit
import CoreGraphics

class HeroesViewController: UIViewController {
    
    @IBOutlet weak var heroesList: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    var heroes = [MarvelCharacter]()
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearch()
        
        self.heroesList.dataSource = self
        self.heroesList.delegate = self
        self.navigationController?.delegate = self
        
        self.heroesList.register(UINib(nibName: "HeroMainCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: "hero_main_cell")
        self.heroesList.register(UINib(nibName: "PaginationCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: "pagination_cell")
        
        FSHLoading.shared.show(true)
        MarvelAPI.getCharacters { (characters, total, error) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBarHeight.constant = 0
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedIndex = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "hero_details",
        let hero = sender as? MarvelCharacter,
        let destination = segue.destination as? HeroDetailsViewController {
            destination.hero = hero
        }
    }
    
    func loadMoreHeroes(_ paginationCell: PaginationCell) {
        
        paginationCell.startLoading()
        
        MarvelAPI
        .getCharacters(Int(floor(Double(heroes.count)*0.05)),
                       handler: { [weak self] (characters, total, error) in
                        
                        paginationCell.stopLoading()
                                    
                        guard
                            let characters = characters,
                            let heroesList = self?.heroesList,
                            let heroesCount = self?.heroes.count,
                            error == nil
                            else {
                                // TODO manage errors
                                return
                        }
                        
                        let heroesListDelta = (heroesCount..<heroesCount + characters.count)
                        let indexes = heroesListDelta.map { IndexPath(row: $0, section: 0) }
                        self?.heroes.append(contentsOf: characters)
                        
                        // Insert new rows animated
                        heroesList.performBatchUpdates({
                            heroesList.insertRows(at: indexes, with: .right)
                        }, completion: nil)
                                    
        })
        
    }
}

extension HeroesViewController: UISearchBarDelegate {
    
    @objc func showSearch() {
        searchBarHeight.constant = 56
        searchBar.becomeFirstResponder()
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideSearch() {
        searchBarHeight.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupSearch() {
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(barButtonSystemItem: .search,
                            target: self,
                            action: #selector(showSearch)),
            animated: false)
        searchBar.searchBarStyle = .minimal
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // perform search
        searchBar.resignFirstResponder()
    }
    
}

extension HeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == heroes.count {
            guard let cell = tableView.cellForRow(at: indexPath) as? PaginationCell else {
                return
            }
            
            loadMoreHeroes(cell)
            
            return
        }
        
        selectedIndex = indexPath
        performSegue(withIdentifier: "hero_details", sender: heroes[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideSearch()
    }
}

extension HeroesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if heroes.count == 0 {
           return 0
        } else {
            return heroes.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == heroes.count {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "pagination_cell",
                                                         for: indexPath) as? PaginationCell
                else {
                    return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            return cell
            
        }
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "hero_main_cell",
                                                     for: indexPath) as? HeroMainCell
        else {
            return UITableViewCell()
        }
        
        cell.imgThumb.image = UIImage(named: "downloadImagePlaceholder")
        
        let hero = heroes[indexPath.row]
        cell.imgThumb.load(hero.thumbnail?.url() ?? "")
        cell.lblName.text = hero.name
        
        cell.selectionStyle = .none
        return cell
        
    }
    
}

extension HeroesViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let selectedIndex = selectedIndex else {
            return nil
        }
        
        switch operation {
        case .push:
            return DetailsTransitionAnimator(from: selectedIndex, transitioning: .into)
        case .pop:
            return DetailsTransitionAnimator(from: selectedIndex, transitioning: .out)
        default:
            return nil
        }
    }
    
}
