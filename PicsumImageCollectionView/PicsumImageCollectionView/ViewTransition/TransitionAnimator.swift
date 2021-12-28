//
//  TransitionAnimator.swift
//  PicsumImageCollectionView
//
//  Created by JinGu's iMac on 2021/12/27.
//

import Foundation
import UIKit

class Interactor : UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

class DismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
           let fromImageVC = fromNaviCon.viewControllers.first as? ImageViewController
        else { return }
        
        guard let toNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController,
              let toMainVC = toNaviCon.viewControllers.first as? MainViewController
        else { return }
        
        toMainVC.tempImageView?.frame = fromImageVC.imageView.frame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromImageVC.view.backgroundColor = UIColor.white.withAlphaComponent(0)
            fromNaviCon.navigationBar.alpha = 0
            fromImageVC.imageView.frame = fromImageVC.cellFrame
            toMainVC.tempImageView?.frame = fromImageVC.cellFrame
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

class PresentAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
           let fromMainVC = fromNaviCon.viewControllers.first as? MainViewController
        else { return }
        
        guard let toNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController,
              let toImageVC = toNaviCon.viewControllers.first as? ImageViewController
        else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toNaviCon.view, belowSubview: fromNaviCon.view)
        
        toNaviCon.view.alpha = 0
        
        let originFrame = toImageVC.imageView.frame
        toImageVC.imageView.frame = toImageVC.cellFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toNaviCon.view.alpha = 1
            toImageVC.imageView.frame = originFrame
            fromMainVC.tempImageView?.frame = originFrame
        } completion: { _ in
            fromMainVC.tempImageView?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
