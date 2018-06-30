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
    var searchTerm: String?
    var pagingEnded: Bool = false
    
    var searchButton: UIBarButtonItem!
    var cancelSearchButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildIcons()
        self.setupSearch()
        
        self.heroesList.dataSource = self
        self.heroesList.delegate = self
        self.navigationController?.delegate = self
        
        self.heroesList.register(UINib(nibName: "HeroMainCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: "hero_main_cell")
        self.heroesList.register(UINib(nibName: "PaginationCell", bundle: Bundle.main),
                                 forCellReuseIdentifier: "pagination_cell")
        
        FSHLoading.shared.show(true)
        MarvelAPI.getCharacters { [weak self] (characters, total, error) in
            FSHLoading.shared.dismiss(true)
            self?.firstLoad(characters, total, error)
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
        let page = Int(floor(Double(heroes.count)*0.05))
        
        guard let search = searchTerm, !search.isEmpty else {
            MarvelAPI
                .getCharacters(page, handler: { [weak self] (characters, total, error) in
                    paginationCell.stopLoading()
                    self?.pagingLoad(characters, total, error)
                })
            return
        }
        
        MarvelAPI
            .searchCharacter(name: search, page: page) { [weak self] (characters, total, error) in
                paginationCell.stopLoading()
                self?.pagingLoad(characters, total, error)
        }
        
        
        
    }
}

extension HeroesViewController { // Network
    
    func pagingLoad(_ characters: [MarvelCharacter]?, _ total: Int?, _ error: Error?) {
        
        guard
            let characters = characters,
            error == nil
            else {
                // TODO manage errors
                return
        }
        
        if total != nil && heroes.count >= total! {
            // no more pages to load
            pagingEnded = true
            
            if let pagingCell = heroesList.cellForRow(
                at: IndexPath(row: heroes.count, section: 0)
            ) as? PaginationCell {
                pagingCell.noMoreResults()
            }
            
            return
        }
        
        let heroesListDelta = (heroes.count..<heroes.count + characters.count)
        let indexes = heroesListDelta.map { IndexPath(row: $0, section: 0) }
        heroes.append(contentsOf: characters)
        
        let previousContentSize = heroesList.contentSize
        
        // Insert new rows animated
        heroesList.performBatchUpdates({
            heroesList.insertRows(at: indexes, with: .right)
        }, completion: { finished in
            
            //if at bottom, scroll last added item to top
            let tableViewHeight = self.heroesList.frame.size.height
            if self.heroesList.contentOffset.y == (previousContentSize.height - tableViewHeight) {
                let firstNewRow = self.heroes.count - characters.count
                self.heroesList.scrollToRow(at: IndexPath(row: firstNewRow, section: 0),
                                            at: .top, animated: true)
            }
            
        })
        
    }
    
    func firstLoad(_ characters: [MarvelCharacter]?, _ total: Int?, _ error: Error?) {
    
        pagingEnded = false
        
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

extension HeroesViewController: UISearchBarDelegate {
    
    @objc func showSearch() {
        searchBarHeight.constant = 56
        searchBar.becomeFirstResponder()
        self.navigationItem.setRightBarButton(cancelSearchButton, animated: true)
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func endSearch() {
        
        if searchTerm == nil {
            hideSearch()
            self.navigationItem.setRightBarButton(searchButton, animated: true)
            searchBar.resignFirstResponder()
            return
        }
        
        searchTerm = nil
        searchBar.text = nil
        
        hideSearch()
        self.navigationItem.setRightBarButton(searchButton, animated: true)
        
        heroes.removeAll()
        heroesList.reloadData()
        
        FSHLoading.shared.show(true)
        MarvelAPI.getCharacters { [weak self] (characters, total, error) in
            FSHLoading.shared.dismiss(true)
            self?.firstLoad(characters, total, error)
        }
        
    }
    
    func hideSearch() {
        searchBarHeight.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func buildIcons() {
        searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                       target: self,
                                       action: #selector(showSearch))
        cancelSearchButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                             target: self,
                                             action: #selector(endSearch))
    }
    
    func setupSearch() {
        self.navigationItem.setRightBarButton(searchButton,
                                              animated: false)
        searchBar.searchBarStyle = .minimal
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // perform search
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        heroes.removeAll()
        heroesList.reloadData()
        
        searchTerm = text
        FSHLoading.shared.show(true)
        MarvelAPI.searchCharacter(name: text) { [weak self] (characters, total, error) in
            FSHLoading.shared.dismiss(true)
            self?.firstLoad(characters, total, error)
        }
        
    }
    
}

extension HeroesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == heroes.count {
        
            guard let cell = tableView.cellForRow(at: indexPath) as? PaginationCell,
            !pagingEnded else {
                
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
           return 0 // show nothing
        } else {
            return heroes.count + 1 // show paging cell
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
            cell.reset()
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
