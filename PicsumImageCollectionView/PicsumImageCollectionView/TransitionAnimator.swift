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
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
           let fromMainVC = fromNaviCon.viewControllers.first as? MainViewController
        else { return }
        
        guard let toNaviCon = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController,
              let toImageVC = toNaviCon.viewControllers.first as? ImageViewController
        else { return }
        
        guard let image = toImageVC.imageView.image else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toNaviCon.view, belowSubview: fromNaviCon.view)
        
        toNaviCon.view.alpha = 0
        
        
        toImageVC.imageView.snp.remakeConstraints{
            $0.leading.equalTo(toImageVC.originImageFrame.origin.x)
            $0.top.equalTo(toImageVC.originImageFrame.origin.y)
            $0.width.equalTo(toImageVC.originImageFrame.size.width)
            $0.height.equalTo(toImageVC.originImageFrame.size.height)
        }
        toImageVC.view.layoutIfNeeded()
        
        toImageVC.imageView.snp.remakeConstraints{
            $0.leading.trailing.top.bottom.equalTo(toImageVC.view.safeAreaLayoutGuide)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toImageVC.view.layoutIfNeeded()
            toNaviCon.view.alpha = 1
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
