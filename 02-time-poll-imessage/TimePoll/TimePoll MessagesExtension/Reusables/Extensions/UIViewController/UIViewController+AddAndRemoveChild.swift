//
//  UIViewController+AddAndRemoveChild.swift
//  TimePoll
//
//  Created by CypherPoet on 3/28/20.
// ✌️
//

#if os(iOS)

import UIKit


@nonobjc public extension UIViewController {
    
    func add(
        child childViewController: UIViewController,
        toView targetView: UIView? = nil,
        framingIn targetFrame: CGRect? = nil
    ) {
        guard let targetView = targetView ?? view else { return }
        let targetFrame = targetFrame ?? view.bounds
        
        childViewController.view.frame = targetFrame
        
        addChild(childViewController)
        targetView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    
    func performRemoval() {
        // Check that this view controller is actually added to
        // a parent before removing it.
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

#endif
