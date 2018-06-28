//
//  FSHLoading.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicatorView: UIView {
    
    var foregroundColor: UIColor?
    var animationStopped: Bool = true
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var leftBar: UIView!
    @IBOutlet weak var rightBar: UIView!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightWidthConstraint: NSLayoutConstraint!
    
    var _space: CGFloat = 0.15
    var space: CGFloat {
        set {
            if newValue > 1.0 {
                _space = 1.0
            } else if newValue < 0 {
                _space = 0
            } else {
                _space = newValue
            }
        }
        get {
            return _space
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.foregroundColor = .lightGray
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
        self.view = loadView()
    }
    
    private func loadView() -> UIView {
        let nib = UINib(nibName: "LoadingIndicatorView", bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    func setup() {
        
        self.view.frame = bounds
        self.addSubview(self.view)
        
        leftBar?.backgroundColor = foregroundColor ?? UIColor.clear
        rightBar?.backgroundColor = foregroundColor ?? UIColor.clear
    }
    
    func stop() {
        animationStopped = true
    }
    
    func play() {
        
        animationStopped = false
        
        let actualSpacing = self.frame.size.width * self.space
        
        setStart()
        self.layoutIfNeeded()
        
        self.setMidPoint(actualSpacing: actualSpacing)
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { [weak self] (finished) in
            self?.setEnd()
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
                self?.layoutIfNeeded()
            }, completion: { _ in
                if !self!.animationStopped {
                    self?.play()
                } else {
                    return
                }
            })
        }
        
    }
    
    func setStart() {
        self.spaceConstraint.constant = 0
        self.leftWidthConstraint.constant = self.frame.size.width
        self.rightWidthConstraint.constant = 0
    }
    
    func setMidPoint(actualSpacing: CGFloat) {
        self.spaceConstraint.constant = actualSpacing
        self.leftWidthConstraint.constant = (self.frame.size.width/2) - (actualSpacing/2)
        self.rightWidthConstraint.constant = (self.frame.size.width/2) - (actualSpacing/2)
    }
    
    func setEnd() {
        self.spaceConstraint.constant = 0
        self.leftWidthConstraint.constant = 0
        self.rightWidthConstraint.constant = self.frame.size.width
    }
    
}


public final class FSHLoading: NSObject {
    
    public static let shared = FSHLoading()
    public typealias DidFinishDismissingHandler = () -> Void
    
    private let defaultAnimationTime: TimeInterval = 0.5
    public var customAnimationDuration: TimeInterval?
    public var isLoading: Bool = false
    
    private var didDismissHandler: DidFinishDismissingHandler?
    
    @IBOutlet var view: UIView!
    @IBOutlet private var smallView: UIView!
    @IBOutlet weak var animationView: LoadingIndicatorView!
    
    // MARK: - LifeCycle
    
    public override init() {
        super.init()
        Bundle.main.loadNibNamed("FSHLoadingView", owner: self, options: nil)
        initAnimationView()
    }
    
    // MARK: - Public
    
    public func show(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground),
                                               name: .UIApplicationWillEnterForeground, object: nil)
        
        if self.isLoading { return }
        self.prepareToShow()
        self.animateIntoScreen(duration: animated ? self.animationDuration() : 0)
        
    }
    
    public func dismiss(_ animated: Bool, handler: DidFinishDismissingHandler? = nil) {
        
        NotificationCenter.default.removeObserver(self)
        
        self.didDismissHandler = handler
        self.animateOutOfScreen(duration: animated ? self.animationDuration() : 0)
    }
    
    // private
    
    @objc private func didEnterForeground() {
        if animationView.animationStopped && isLoading {
            animationView.play()
        }
    }
    
    private func initAnimationView() {
        self.view.layoutIfNeeded()
    }
    
    private func animationDuration() -> TimeInterval {
        guard let customTime = self.customAnimationDuration else {
            return self.defaultAnimationTime
        }
        return customTime
    }
    
    private func prepareToShow() {
        
        guard let window = UIApplication.shared.delegate?.window
            else {
                return
        }
        
        self.animationView.play()
        self.smallView.alpha = 0.0
        self.view.frame = window!.frame
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.view.layoutIfNeeded()
        
        window?.addSubview(self.view)
        
    }
    
    private func animateIntoScreen(duration: TimeInterval) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: duration, animations: {
            self.smallView.alpha = 1.0
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.layoutIfNeeded()
        }) { finished in
            self.didFinishShowing()
        }
        
    }
    
    private func didFinishShowing() {
        isLoading = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func animateOutOfScreen(duration: TimeInterval) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: duration, animations: {
            self.smallView.alpha = 0.0
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.layoutIfNeeded()
        }) { finished in
            self.animationView.stop()
            self.didFinishHiding()
        }
        
    }
    
    private func didFinishHiding() {
        UIApplication.shared.endIgnoringInteractionEvents()
        guard let handler = self.didDismissHandler else {
            self.view.removeFromSuperview()
            isLoading = false
            return
        }
        handler()
        self.view.removeFromSuperview()
        isLoading = false
    }
}
