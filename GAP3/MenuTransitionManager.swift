//
//  MenuTransitionManager.swift
//  Menu
//
//  Created by Mathew Sanders on 9/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    
    
    
    
    
    
    
    private var presenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuController(menuViewController)
        }
        
        // add the both views to our view controller
        container!.addSubview(bottomView)
        container!.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
            // set a transition style
        //let transitionOptions = UIViewAnimationOptions.TransitionNone
        
        // perform the animation!
        
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
            
            if (self.presenting){
                self.onStageMenuController(menuViewController) // onstage items: slide in
            }
            else {
                self.offStageMenuController(menuViewController) // offstage items: slide out
            }
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                
        })
        
    }
    
    /*
        
        UIView.animateWithDuration(1.0,  delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            
            if (self.presenting){
                self.onStageMenuController(menuViewController) // onstage items: slide in
            }
            else {
                self.offStageMenuController(menuViewController) // offstage items: slide out
            }
            
            }, completion: { (finished: Bool) in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                
                
        })
        
    }
    
    */

    
    func offStageMenuController(menuViewController: MenuViewController){
        
        menuViewController.view.alpha = 0
        
        // setup 2D transitions for animations
        let offstageLeft = CGAffineTransformMakeTranslation(-150, 0)
        let offstageRight = CGAffineTransformMakeTranslation(150, 0)
        
        menuViewController.textPostIcon.transform = offstageLeft
        menuViewController.textPostLabel.transform = offstageLeft
        
        menuViewController.quotePostIcon.transform = offstageLeft
        menuViewController.quotePostLabel.transform = offstageLeft
        
        menuViewController.chatPostIcon.transform = offstageLeft
        menuViewController.chatPostLabel.transform = offstageLeft
        
        menuViewController.photoPostIcon.transform = offstageRight
        menuViewController.photoPostLabel.transform = offstageRight
        
        menuViewController.linkPostIcon.transform = offstageRight
        menuViewController.linkPostLabel.transform = offstageRight
        
        menuViewController.audioPostIcon.transform = offstageRight
        menuViewController.audioPostLabel.transform = offstageRight
        
        
        
    }
    
    func onStageMenuController(menuViewController: MenuViewController){
        
        // prepare menu to fade in
        menuViewController.view.alpha = 1
        
        menuViewController.textPostIcon.transform = CGAffineTransformIdentity
        menuViewController.textPostLabel.transform = CGAffineTransformIdentity
        
        menuViewController.quotePostIcon.transform = CGAffineTransformIdentity
        menuViewController.quotePostLabel.transform = CGAffineTransformIdentity
        
        menuViewController.chatPostIcon.transform = CGAffineTransformIdentity
        menuViewController.chatPostLabel.transform = CGAffineTransformIdentity
        
        menuViewController.photoPostIcon.transform = CGAffineTransformIdentity
        menuViewController.photoPostLabel.transform = CGAffineTransformIdentity
        
        menuViewController.linkPostIcon.transform = CGAffineTransformIdentity
        menuViewController.linkPostLabel.transform = CGAffineTransformIdentity
        
        menuViewController.audioPostIcon.transform = CGAffineTransformIdentity
        menuViewController.audioPostLabel.transform = CGAffineTransformIdentity
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}
