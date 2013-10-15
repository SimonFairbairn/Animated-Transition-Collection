//
//  ATCAnimatedTransitioningBounce.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioningBounce.h"

@interface ATCAnimatedTransitioningBounce ()


@end

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
    
    if ( self.isInteractive && !self.isDismissal ) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] init];
        [gesture addTarget:self action:@selector(handleGesture:)];
        [toVC.view addGestureRecognizer:gesture];
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
        self.isInteracting = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer {
   
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.isInteracting = YES;
            [self.destinationViewController dismissViewControllerAnimated:YES completion:^{
            }];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            UIView *view = recognizer.view.superview;
            CGPoint translation = [recognizer translationInView:view];
            CGFloat percentTransitioned = (translation.y / CGRectGetHeight(view.frame));
            [self.interactiveTransition updateInteractiveTransition:percentTransitioned];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ( self.interactiveTransition.percentComplete > 0.25 ) {
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
