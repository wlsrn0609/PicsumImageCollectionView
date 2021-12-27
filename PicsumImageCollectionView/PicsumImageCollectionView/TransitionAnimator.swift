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
