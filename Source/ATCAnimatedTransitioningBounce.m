//
//  ATCAnimatedTransitioningBounce.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCAnimatedTransitioningBounce.h"

#define ATCAnimatedTransitioningBounceDebugLog 0

@interface ATCAnimatedTransitioningBounce ()

@end

@implementation ATCAnimatedTransitioningBounce


-(void)animateTransitionWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
                 fromViewController:(UIViewController *)fromViewController
                   toViewController:(UIViewController *)toViewController
                           fromView:(UIView *)fromView
                             toView:(UIView *)toView {
    
    UIView *container = [transitionContext containerView];
    CGRect toVCFrame = toViewController.view.frame;
    CGRect fromVCFrame = fromViewController.view.frame;
    CGRect finalFrame = fromVCFrame;
    CGFloat padding = 20.0f;
    
    
    ATCTransitionAnimationDirection direction = [self adjustDirectionForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    if (self.isDismissal) {
       
        switch (direction) {
            case ATCTransitionAnimationDirectionNone:
            case ATCTransitionAnimationDirectionLeft: {
                finalFrame = CGRectMake(CGRectGetWidth(fromVCFrame) + padding, fromVCFrame.origin.y, CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
                break;
            }
            case ATCTransitionAnimationDirectionBottom: {
                finalFrame = CGRectMake(fromVCFrame.origin.x, CGRectGetHeight(fromVCFrame) + padding, CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
                
                break;
            }
            case ATCTransitionAnimationDirectionTop: {
                finalFrame = CGRectMake(fromVCFrame.origin.x, -(CGRectGetHeight(fromVCFrame) + padding), CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
                
                break;
            }
            case ATCTransitionAnimationDirectionRight: {
                finalFrame = CGRectMake(fromVCFrame.origin.x - (CGRectGetWidth(fromVCFrame) + padding), fromVCFrame.origin.y, CGRectGetWidth(fromVCFrame), CGRectGetHeight(fromVCFrame));
                
                break;
            }
            default:
                break;
        }
        
        
    } else {
        // Set up initial state
        [container addSubview:toView];
        toVCFrame.origin.y = toVCFrame.size.height + padding;
        
        switch (direction) {
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
        toView.frame = toVCFrame;
    }
    
    toVCFrame = fromVCFrame;
    if ( self.isInteracting ) {
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
            fromViewController.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            self.interacting = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if ( self.isDismissal ) {
                fromViewController.view.frame = finalFrame;
            } else {
                toViewController.view.frame = toVCFrame;
            }
            
        } completion:^(BOOL finished) {
            self.interacting = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}


-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer inViewController:(UIViewController *)controller {

#ifdef DEBUG
#if ATCAnimatedTransitioningBounceDebugLog
    NSLog(@"%@", self.destinationViewController);
#endif
#endif
    
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
            
            UIView *view = recognizer.view.superview;
            CGFloat percentTransitioned = 0.0f;
            CGPoint translation = [recognizer translationInView:view];
            if ( self.direction == ATCTransitionAnimationDirectionLeft ) {
                percentTransitioned = (translation.x / CGRectGetWidth(view.frame));
            } else if ( self.direction == ATCTransitionAnimationDirectionRight ) {
                percentTransitioned = fabs(translation.x / CGRectGetWidth(view.frame));
            } else if ( self.direction == ATCTransitionAnimationDirectionTop ) {
                percentTransitioned = fabs(translation.y / CGRectGetHeight(view.frame));
            } else if ( self.direction == ATCTransitionAnimationDirectionBottom ) {
                percentTransitioned = translation.y / CGRectGetHeight(view.frame);
            } else {
                percentTransitioned = fabs(translation.y / CGRectGetHeight(view.frame));
                CGFloat percentTransitionedX = fabs(translation.x / CGRectGetWidth(view.frame));
                percentTransitioned = ( percentTransitionedX > percentTransitioned ) ? percentTransitionedX : percentTransitioned;
            }
            
            
            if (percentTransitioned >= 1.0)
                percentTransitioned = 0.99;
            [self.interactiveTransition updateInteractiveTransition:percentTransitioned];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [recognizer velocityInView:recognizer.view.superview];
            CGFloat velocitySpeed = 1.0f;
            
            if ( self.direction == ATCTransitionAnimationDirectionLeft ) {
                velocitySpeed = (velocity.x / recognizer.view.superview.frame.size.width);
            } else if ( self.direction == ATCTransitionAnimationDirectionRight ) {
                velocitySpeed = fabs((velocity.x / recognizer.view.superview.frame.size.width));
            } else if ( self.direction == ATCTransitionAnimationDirectionTop ) {
                velocitySpeed = fabs((velocity.y / recognizer.view.superview.frame.size.height));
            } else if ( self.direction == ATCTransitionAnimationDirectionBottom ) {
                velocitySpeed = (velocity.y / recognizer.view.superview.frame.size.height);
            }
            
            if ( velocitySpeed < 1 ) velocitySpeed = 1;
            
            self.interactiveTransition.completionSpeed = self.interactiveTransition.completionSpeed * velocitySpeed;
            
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
