//
//  ATCAnimatedTransitioningFade.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioningFade.h"

@interface ATCAnimatedTransitioningFade ()

@end

@implementation ATCAnimatedTransitioningFade

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    if ( self.isDismissal ) {
        [[transitionContext containerView] sendSubviewToBack:toVC.view];
    }

    
    if ( !self.isDismissal ) {
        toVC.view.alpha = 0.0f;
    }

    
    if ( self.isInteractive && !self.isDismissal ) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] init];
        [gesture addTarget:self action:@selector(handleGesture:)];
        [toVC.view addGestureRecognizer:gesture];
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:0
                     animations:^{
                         
                         
                         if ( !self.isDismissal ) {
                             toVC.view.alpha = 1.f;
                         } else {
                             fromVC.view.alpha = 0.0f;
                         }

                     }
                     completion:^(BOOL finished) {
                         self.isInteracting = NO;
                         if ( ![transitionContext transitionWasCancelled]) {
                             [fromVC.view removeFromSuperview];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
    
}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer {

    // Are we dealing with a navigation controller?

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.isInteracting = YES;
            if ( self.isPush ) {
                [(UINavigationController *)self.destinationViewController.parentViewController popViewControllerAnimated:YES];
            } else {
                [self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
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
                percentTransitioned = fabsf(translation.y / CGRectGetHeight(view.frame));
                percentTransitionedX = fabsf(translation.x / CGRectGetWidth(view.frame));
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
