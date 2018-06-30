//
//  DetailsTransitionAnimator.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 28/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class DetailsTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Transition {
        case into
        case out
    }
    
    let indexPath: IndexPath
    var transition: Transition = .into
    
    required init(from indexPath: IndexPath, transitioning: Transition) {
        self.indexPath = indexPath
        self.transition = transitioning
    }
    
    func transitionDuration(using
        transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let toVC = transitionContext.viewController(forKey: (transition == .into) ? .to : .from) as? HeroDetailsViewController,
            let fromVC = transitionContext.viewController(forKey: (transition == .into) ? .from : .to) as? HeroesViewController
        else {
            return
        }
        
        //setup participating views
        let container = transitionContext.containerView
        toVC.view.frame = fromVC.view.frame
        
        switch transition {
        case .into:
            container.addSubview(toVC.view)
        case .out:
            container.insertSubview(fromVC.view, belowSubview: toVC.view)
        }

        container.layoutIfNeeded()
        
        // create a copy of the selected cell's elements
        guard
            let originCell = fromVC.heroesList.cellForRow(at: indexPath) as? HeroMainCell,
            let originImageCopy = makeCopy(object: originCell.imgThumb)
        else {
            return
        }
        
        // create snapshots and calculate frames
        let labelSnapshot = originCell.lblName.snapshotView(afterScreenUpdates: transition == .out)!
        labelSnapshot.frame = container.convert(originCell.lblName.frame, from: originCell.lblName.superview)
        originImageCopy.frame = originCell.imgThumb.convert(originCell.imgThumb.frame, to: container)
        originImageCopy.layer.borderColor = UIColor.black.cgColor
        originImageCopy.layer.borderWidth = 2.0
        
        let fromSnapshots: [UIView]
        let toSnapshots: [UIView]
        
        switch transition {
        case .into:
            
            fromSnapshots = [originImageCopy, labelSnapshot]
            toSnapshots = [toVC.imgThumbnail, toVC.lblName].map { (subview: UIView) -> UIView in
                let snapshot = subview.snapshotView(afterScreenUpdates: true)!
                snapshot.frame = container.convert(subview.frame, from: subview.superview)
                return snapshot
            }
            
        case .out:
            
            toSnapshots = [originImageCopy, labelSnapshot]
            fromSnapshots = [toVC.imgThumbnail, toVC.lblName].map { (subview: UIView) -> UIView in
                let snapshot = subview.snapshotView(afterScreenUpdates: false)!
                snapshot.frame = container.convert(subview.frame, from: subview.superview)
                return snapshot
            }
            
            fromSnapshots[0].contentMode = .scaleAspectFill
            fromSnapshots[0].clipsToBounds = true
            fromSnapshots[0].layer.borderColor = UIColor.black.cgColor
            fromSnapshots[0].layer.borderWidth = 2.0
            
        }
        
        let frames = zip(fromSnapshots, toSnapshots).map { ($0.frame, $1.frame) }
        fromSnapshots.forEach { container.addSubview($0) }
        
        // position toViewController outside of screen
        switch transition {
        case .into:
            toVC.view.frame.origin.x = toVC.view.frame.size.width
        case .out:
            fromVC.view.frame.origin.x = -fromVC.view.frame.size.width
        }
        
        // temprarily hide images
        originCell.alpha = 0
        toVC.imgThumbnail.alpha = 0
        toVC.lblName.alpha = 0
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
        animations: {

            // Animate moving objects
            zip(fromSnapshots, frames).forEach { snapshot, frame in
                snapshot.frame = frame.1
            }
            
            // animate screens
            switch self.transition {
            case .into:
                fromVC.view.frame.origin.x = -fromVC.view.frame.size.width
                toVC.view.frame.origin.x = 0
            case .out:
                toVC.view.frame.origin.x = toVC.view.frame.size.width
                fromVC.view.frame.origin.x = 0
            }
            
        }) { (finished) in

            //restore state
            originCell.alpha = 1
            toVC.imgThumbnail.alpha = 1
            toVC.lblName.alpha = 1
            fromSnapshots.forEach { $0.removeFromSuperview() }

            transitionContext.completeTransition(finished)
            
        }
        
    }
    
    func makeCopy<T>(object: T) -> T? where T: UIView {
        
        let copyData = NSKeyedArchiver.archivedData(withRootObject: object)
        guard
            let copiedObj = NSKeyedUnarchiver.unarchiveObject(with: copyData) as? T
        else {
            return nil
        }
        
        copiedObj.translatesAutoresizingMaskIntoConstraints = true
        return copiedObj
    }
    
}
