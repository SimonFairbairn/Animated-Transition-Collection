//
//  ATCAnimatedTransitioningBounce.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioningBounce.h"

@implementation ATCAnimatedTransitioningBounce

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    if ( ![[[transitionContext containerView] subviews] containsObject:toVC]) {
        [[transitionContext containerView] addSubview:toVC.view];
        if ( self.isDismissal ) {
            [[transitionContext containerView] sendSubviewToBack:toVC.view];
        }

    }
    
    
    float padding = 20.0f;
    
    CGRect fromVCFrame = fromVC.view.frame;
    CGRect toVCFrame = fromVCFrame;
    
    switch (self.direction) {
        case ATCTransitionAnimationDirectionNone:
        case ATCTransitionAnimationDirectionLeft: {
            toVCFrame = CGRectMake(CGRectGetWidth(fromVCFrame) + padding, fromVCFrame.origin.y, CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
            break;
        }
        case ATCTransitionAnimationDirectionBottom: {
            toVCFrame = CGRectMake(fromVCFrame.origin.x, CGRectGetHeight(fromVCFrame) + padding, CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
            
            break;
        }
        case ATCTransitionAnimationDirectionTop: {
            toVCFrame = CGRectMake(fromVCFrame.origin.x, -(CGRectGetHeight(fromVCFrame) + padding), CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
            
            break;
        }
        case ATCTransitionAnimationDirectionRight: {
            toVCFrame = CGRectMake(fromVCFrame.origin.x - (CGRectGetWidth(fromVCFrame) + padding), fromVCFrame.origin.y, CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
            
            break;
        }
        default:
            break;
    }
    
    if ( !self.isDismissal ) {
        toVC.view.frame = toVCFrame;
    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
        if ( self.isDismissal ) {
            fromVC.view.frame = toVCFrame;
        } else {
            toVC.view.frame = fromVCFrame;
        }
        
        
    } completion:^(BOOL finished) {

        [transitionContext completeTransition:YES];
    }];


    
}

@end
