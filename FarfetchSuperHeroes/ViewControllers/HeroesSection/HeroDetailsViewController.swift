//
//  HeroDetailsViewController.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

struct DetailsCollection {
    var comics = [MarvelComic]()
    var series = [MarvelSerie]()
    var events = [MarvelEvent]()
    var stories = [MarvelStory]()
    
    var isEmpty: Bool {
        get {
            return
                comics.isEmpty &&
                series.isEmpty &&
                events.isEmpty &&
                stories.isEmpty
        }
    }
}

class HeroDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viwInfo: UIView!
    @IBOutlet weak var stackInfo: UIStackView!
    
    @IBOutlet weak var viwLoadingContainer: UIView!
    @IBOutlet weak var viwLoadingView: LoadingIndicatorView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var hero: MarvelCharacter? = nil
    var detailsCollection = DetailsCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let hero = hero {
            lblName.text = hero.name
            imgThumbnail.load(hero.thumbnail?.url() ?? "")
        }
        
        drawImageFrame()
        downloadAllDetails()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func drawImageFrame() {
        
        self.viwLoadingView.foregroundColor = UIColor.black
        self.imgThumbnail.layer.borderColor = UIColor.black.cgColor
        self.imgThumbnail.layer.borderWidth = 2.0
        self.viwInfo.layer.borderColor = UIColor.black.cgColor
        self.viwInfo.layer.borderWidth = 2.0
    }
    
}

extension HeroDetailsViewController {
    
    func loadDetails() {
        
        if detailsCollection.isEmpty {
            viwLoadingContainer.isHidden = true
            viwLoadingView.stop()
            lblNoData.isHidden = false
            return
        }
        
        if let comicsStack = buildStack(for: detailsCollection.comics,
                                        name: "Is in:") {
            stackInfo.addArrangedSubview(comicsStack.view)
        }
        if let eventsStack = buildStack(for: detailsCollection.events,
                                        name: "Participated in:") {
            stackInfo.addArrangedSubview(eventsStack.view)
        }
        if let storiesStack = buildStack(for: detailsCollection.stories,
                                        name: "Featured in:") {
            stackInfo.addArrangedSubview(storiesStack.view)
        }
        if let seriesStack = buildStack(for: detailsCollection.series,
                                        name: "Appears in the series:") {
            stackInfo.addArrangedSubview(seriesStack.view)
        }
        
        stackInfo.translatesAutoresizingMaskIntoConstraints = false
        stackInfo.invalidateIntrinsicContentSize()
        self.view.layoutIfNeeded()
        
        viwLoadingContainer.isHidden = true
        viwLoadingView.stop()
        
    }
    
    func buildStack(for list: [Summarizable], name: String) -> DetailsStack? {
        
        if list.isEmpty {
            return nil
        }
        
        let listView = DetailsStack(frame: CGRect.zero)
        listView.title.text = name
        
        list.forEach { (object) in
            listView.addDetailView(name: object.name(), text: object.summary())
        }
        listView.invalidateIntrinsicContentSize()
        
        return listView
    }
    
}

extension HeroDetailsViewController {
    
    func downloadAllDetails() {
        
        guard let heroID = hero?.id else {
            return
        }
        
        viwLoadingContainer.isHidden = false
        viwLoadingView.play()
        
        let queue = DispatchQueue(label: "com.details.download", qos: .userInitiated)
        download(in: queue, for: heroID) {
            self.loadDetails()
        }
        
    }
    
    func appendContents<T>(from collection: [T], to: inout [T]) where T: Decodable {
        
        if collection.count >= 3 {
            to.append(contentsOf: collection.prefix(upTo: 3))
        } else {
            to.append(contentsOf: collection.prefix(upTo: collection.count))
        }
    }
    
    func download(in queue: DispatchQueue, for heroID: Int, finished: @escaping () -> ()) {
        
        let downloadGroup = DispatchGroup()
        
        queue.async {
            
            downloadGroup.enter()
            MarvelAPI.getComics(for: heroID, handler: { (comics, error) in
                
                guard let comics = comics, comics.count > 0, error == nil else {
                    downloadGroup.leave()
                    return
                }
                
                self.appendContents(from: comics, to: &self.detailsCollection.comics)
                downloadGroup.leave()
            })
            
            downloadGroup.enter()
            MarvelAPI.getSeries(for: heroID, handler: { (series, error) in
                
                guard let series = series, series.count > 0, error == nil else {
                    downloadGroup.leave()
                    return
                }
                
                self.appendContents(from: series, to: &self.detailsCollection.series)
                downloadGroup.leave()
            })
            
            downloadGroup.enter()
            MarvelAPI.getEvents(for: heroID, handler: { (events, error) in
                
                guard let events = events, events.count > 0, error == nil else {
                    downloadGroup.leave()
                    return
                }
                
                self.appendContents(from: events, to: &self.detailsCollection.events)
                downloadGroup.leave()
            })
            
            downloadGroup.enter()
            MarvelAPI.getStories(for: heroID, handler: { (stories, error) in
                
                guard let stories = stories, stories.count > 0, error == nil else {
                    downloadGroup.leave()
                    return
                }
                
                self.appendContents(from: stories, to: &self.detailsCollection.stories)
                downloadGroup.leave()
            })
            
            downloadGroup.notify(queue: DispatchQueue.main, execute: {
                finished()
            })
            
        }
        
    }
}
