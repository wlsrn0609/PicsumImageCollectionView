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
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
           let fromImageVC = fromNaviCon.viewControllers.first as? ImageViewController
        else { return }
        

        let afterFrame = fromImageVC.originImageFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromImageVC.view.frame = afterFrame
            fromNaviCon.view.alpha = 0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

class PresentAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
           let fromMainVC = fromNaviCon.viewControllers.first as? MainViewController
        else { return }
        
        guard let toNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController,
              let toImageVC = toNaviCon.viewControllers.first as? ImageViewController
        else { return }
        
        guard let image = toImageVC.imageView.image else { return }
        
        print("일단 여기까지 오는건가")
        
        let containerView = transitionContext.containerView
//        containerView.insertSubview(toImageVC.view, belowSubview: fromMainVC.view)
        containerView.insertSubview(toNaviCon.view, belowSubview: fromNaviCon.view)
        
        
        var afterFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * (image.size.height / image.size.width))
        afterFrame.origin.y = (UIScreen.main.bounds.size.height + afterFrame.height) / 2

        
        toImageVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        toNaviCon.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        toNaviCon.view.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toNaviCon.view.alpha = 1
            toImageVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
