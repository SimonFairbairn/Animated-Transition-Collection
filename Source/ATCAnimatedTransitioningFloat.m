//
//  ATCAnimatedTransitioningFloat.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 07/03/2014.
//  Copyright (c) 2014 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioningFloat.h"

@implementation ATCAnimatedTransitioningFloat

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    if ( self.isDismissal ) {
        [[transitionContext containerView] sendSubviewToBack:toVC.view];
    }
    
    toVC.view.alpha = 0.0f;
    if ( !self.isDismissal ) {
        toVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } else {
        toVC.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:0
                     animations:^{
                         
                         toVC.view.alpha = 1.0f;
                         toVC.view.transform = CGAffineTransformIdentity;
                         
                         if ( !self.isDismissal ) {
                             fromVC.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         } else {
                             fromVC.view.alpha = 0.0f;
                             fromVC.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
                         }
                     }
                     completion:^(BOOL finished) {
                         self.interacting = NO;
                         fromVC.view.transform = CGAffineTransformIdentity;
                         if ( ![transitionContext transitionWasCancelled]) {
                             [fromVC.view removeFromSuperview];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
    
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer inViewController:(UIViewController *)controller {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.interacting = YES;
            if ( self.isPush ) {
                [(UINavigationController *)controller.parentViewController popViewControllerAnimated:YES];
            } else {
                [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // TODO: Calculate based on opposite direction
            UIView *view = recognizer.view.superview;
            CGPoint translation = [recognizer translationInView:view];
            CGFloat percentTransitioned;
            CGFloat percentTransitionedX;
            
            if ( self.isPush ) {
                percentTransitioned =  translation.x / CGRectGetWidth(view.frame);
            } else {
                percentTransitioned = fabs(translation.y / CGRectGetHeight(view.frame));
                percentTransitionedX = fabs(translation.x / CGRectGetWidth(view.frame));
                percentTransitioned = ( percentTransitionedX > percentTransitioned ) ? percentTransitionedX : percentTransitioned;
            }
            
            [self.interactiveTransition updateInteractiveTransition:percentTransitioned];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if ( [self.interactiveTransition percentComplete] > 0.25 ) {
                [self.interactiveTransition finishInteractiveTransition];
            } else {
                
                [self.interactiveTransition cancelInteractiveTransition];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self.interactiveTransition cancelInteractiveTransition];
            
            break;
        }
        default:{
            break;
        }
    }
}


@end
